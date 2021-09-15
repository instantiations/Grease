"
A GRPharoPlatform is the Pharo implementation of GRPlatform, the Grease class that provides functionality that can not be implemented in a platform independent way.

"
Class {
	#name : #GRPharoPlatform,
	#superclass : #GRPlatform,
	#classVars : [
		'UrlTable',
		'XmlTable'
	],
	#category : 'Grease-Squeak6-Core'
}

{ #category : #'class initialization' }
GRPharoPlatform class >> initialize [
	self initializeXmlTable.
	self initializeUrlTable.
	self select
]

{ #category : #'class initialization' }
GRPharoPlatform class >> initializeUrlTable [
	UrlTable := ByteArray new: 256.
	1 to: 256 do: [ :index |
		('ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_.~' includes: (Character codePoint: index - 1))
			ifTrue: [ UrlTable at: index put: 0 ]
			ifFalse: [ UrlTable at: index put: 1 ] ]
]

{ #category : #'class initialization' }
GRPharoPlatform class >> initializeXmlTable [
	XmlTable := ByteArray new: 256.
	1 to: 256 do: [ :index |
		('"<&>' includes: (Character codePoint: index - 1))
			ifTrue: [ XmlTable at: index put: 1 ]
			ifFalse: [ XmlTable at: index put: 0 ] ]
]

{ #category : #'class initialization' }
GRPharoPlatform class >> unload [
	self unselect
]

{ #category : #startup }
GRPharoPlatform >> addToShutDownList: anObject [
	"Add anObject to the shutdown-list of the system. On shutdown the message #shutDown will be sent to anObject."

	Smalltalk addToShutDownList: anObject
]

{ #category : #startup }
GRPharoPlatform >> addToStartUpList: anObject [
	"Add anObject to the startup-list of the system. On startup the message #startUp will be sent to anObject."

	Smalltalk addToStartUpList: anObject
]

{ #category : #'file library' }
GRPharoPlatform >> asMethodReturningByteArray: aByteArrayOrString named: aSymbol [
	"Generates the source of a method named aSymbol that returns aByteArrayOrString as a ByteArray"
	^ self useByteArrayLiterals
		ifTrue: [ self asMethodReturningByteArrayLiteral: aByteArrayOrString named: aSymbol ]
		ifFalse: [ self asMethodReturningByteArrayWithCache: aByteArrayOrString named: aSymbol ]
]

{ #category : #'private-file library' }
GRPharoPlatform >> asMethodReturningByteArrayLiteral: aByteArrayOrString named: aSymbol [
	"Generates the source of a method named aSymbol that returns aByteArrayOrString as a byte array using VW/NewCompiler byte array literal syntax."
	^ String streamContents: [ :stream |
		stream nextPutAll: aSymbol; nextPut: Character cr.
		stream tab; nextPutAll: '^ #['.
		aByteArrayOrString asByteArray
			do: [ :each | each printOn: stream ]
			separatedBy: [ stream space ].
		stream nextPutAll: ']' ]
]

{ #category : #'private-file library' }
GRPharoPlatform >> asMethodReturningByteArrayWithCache: aByteArrayOrString named: aSymbol [
	"Generates the source of a method named aSymbol that returns aByteArrayOrString as a byte array and caching this array in a literal array of size 1."
	^ String streamContents: [ :stream |
		stream nextPutAll: aSymbol; nextPut: Character cr.
		stream tab; nextPutAll: '^ #('.
		aByteArrayOrString asByteArray
			do: [ :each | each printOn: stream ]
			separatedBy: [ stream space ].
		stream nextPutAll: ') asByteArray' ]
]

{ #category : #encoding }
GRPharoPlatform >> base64Decode: aString [
	^ (Base64MimeConverter mimeDecodeToChars: aString readStream) contents
]

{ #category : #bindings }
GRPharoPlatform >> bindingOf: aClass [
	"theoretically consider the environment of a class"
	^ aClass binding
]

{ #category : #'file library' }
GRPharoPlatform >> compile: aString into: aClass classified: aSymbol [ 
	"The trick here is to be as silently a possible so that the package is not marked dirty when running WAFileLibrary test.
	This also makes running tests much faster."
	| methodNode compiledMethod selector methodAndNode |
	methodNode := aClass compilerClass new 
		compile: aString
		in: aClass
		notifying: nil
		ifFail: [ GRError signal: 'syntax error' ].
	selector := methodNode selector.
	methodAndNode := CompiledMethodWithNode 
		generateMethodFromNode: methodNode
		trailer: aClass defaultMethodTrailer.
	compiledMethod := methodAndNode method.
	compiledMethod 
		putSource: aString
		fromParseNode: methodAndNode node
		inFile: 2
		withPreamble: [ :file | 
			aClass
				printCategoryChunk: aSymbol asString
				on: file priorMethod: (aClass compiledMethodAt: selector ifAbsent: [ nil ]).
			file cr ].
	aClass 
		addSelectorSilently: selector
		withMethod: compiledMethod.
	SystemChangeNotifier uniqueInstance doSilently:  [
		aClass organization 
			classify: selector
			under: aSymbol ]
]

{ #category : #'file library' }
GRPharoPlatform >> contentsOfFile: aString binary: aBoolean [
	| stream |
	stream := aBoolean
		ifTrue: [ (FileDirectory default oldFileNamed: aString)
			binary;
			yourself ]
		ifFalse: [ (MultiByteFileStream oldFileNamed: aString)
			ascii;
			wantsLineEndConversion: true;
			yourself ].
	^ [ stream contents ] ensure: [ stream close ]
]

{ #category : #exceptions }
GRPharoPlatform >> deprecationExceptionSet [
	^ Deprecation
]

{ #category : #'file library' }
GRPharoPlatform >> directoriesIn: aPathString [
	"Answer a collection of absolute paths for all the directories (no files) in the directory given by aPathString
	must not include directory names that start with ."
	| directory |
	directory := FileDirectory default directoryNamed: aPathString.
	^ (directory directoryNames
		reject: [ :each | each first = $. ])
		collect: [ :each | directory fullNameFor: each ]
]

{ #category : #private }
GRPharoPlatform >> doSilently: aBlock [
	^ SystemChangeNotifier uniqueInstance doSilently:  aBlock
]

{ #category : #'file library' }
GRPharoPlatform >> ensureExistenceOfFolder: aString [
	"creates a folder named aString in the image directory"
	FileDirectory default assureExistenceOfPath: aString
]

{ #category : #'file library' }
GRPharoPlatform >> fileExists: aString [
	^ (FileDirectory on: aString) exists
]

{ #category : #'file library' }
GRPharoPlatform >> fileStreamOn: aString do: aBlock binary: aBoolean [
	^ aBoolean
		ifTrue: [
			FileStream oldFileNamed: aString do: [ :stream |
				stream binary.
				aBlock value: stream ] ]
		ifFalse: [
			MultiByteFileStream oldFileNamed: aString do: [ :stream |
				stream
					ascii;
					wantsLineEndConversion: true.
					aBlock value: stream ] ]
]

{ #category : #'file library' }
GRPharoPlatform >> filesIn: aPathString [
	"Return a collection of absolute paths for all the files (no directories) in the directory given by aPathString
	must not include file names that start with ."
	| directory |
	directory := FileDirectory default directoryNamed: aPathString.
	^ (directory fileNames
		reject: [ :each | each first = $. ])
		collect: [ :each | directory fullNameFor: each ]
]

{ #category : #processes }
GRPharoPlatform >> isProcessTerminated: aProcess [
	"Return a boolean indicating whether aProcess has been terminated."
	^ aProcess isTerminated
]

{ #category : #'version info' }
GRPharoPlatform >> label [
	^ 'Pharo'
]

{ #category : #'file library' }
GRPharoPlatform >> localNameOf: aFilename [
	^ (FileDirectory on: aFilename) localName
]

{ #category : #factory }
GRPharoPlatform >> newRandom [
	"Answers the random number generator to be used to create session and continuation keys. Make sure it is seeded. They only methods that will be sent to it are:
	  #nextInt: - should answer a random integer in the interval [1, anInteger]
	  #randomFrom: - should answer a random element from the given collection
	
	Make sure that both methods are safe under heavy concurrent load.
	
	Used by Gemstone/S traditional Randoms which cannot be persisted.."
	^ ThreadSafeRandom value
]

{ #category : #'file library' }
GRPharoPlatform >> newline [
	^ String with: Character cr
]

{ #category : #exceptions }
GRPharoPlatform >> openDebuggerOn: anError [
	| process |
	process := Processor activeProcess.
	"If we are running in the UI process, we don't want to suspend the active process. The
	error was presumably triggered while stepping in the Debugger. If we simply immediately
	signal an UnhandledError, the debugger will catch this and display the signaling context.
	It isn't perfect or pretty but it works."
	(ProcessBrowser isUIProcess: process)
		ifTrue: [
			UnhandledError signalForException: anError ]
		ifFalse: [
			WorldState addDeferredUIMessage: [
				process
					debug: anError signalerContext
					title: anError description
					full: true ].
			process suspend ]
]

{ #category : #'file library' }
GRPharoPlatform >> pathSeparator [
	^ FileDirectory pathNameDelimiter asString
]

{ #category : #factory }
GRPharoPlatform >> readWriteByteStream [
	"ByteArray based read write stream"
	
	^ RWBinaryOrTextStream on: (ByteArray new: 4096)
]

{ #category : #factory }
GRPharoPlatform >> readWriteCharacterStream [
	"String based read write stream"

	^ ReadWriteStream on: (String new: 4096)
]

{ #category : #startup }
GRPharoPlatform >> removeFromShutDownList: anObject [
	"Remove anObject from the shutdown list in the system."

	Smalltalk removeFromShutDownList: anObject
]

{ #category : #startup }
GRPharoPlatform >> removeFromStartUpList: anObject [
	"Remove anObject from the startup list in the system."

	Smalltalk removeFromStartUpList: anObject
]

{ #category : #'file library' }
GRPharoPlatform >> removeSelector: aSymbol from: aClass [
	aClass removeSelectorSilently: aSymbol
]

{ #category : #cryptography }
GRPharoPlatform >> secureHashFor: aString [
	^ SecureHashAlgorithm new hashMessage: aString
]

{ #category : #factory }
GRPharoPlatform >> semaphoreClass [
	"used by Gemstone/S traditional Semaphores which cannot be persisted"
	^ Semaphore
]

{ #category : #exceptions }
GRPharoPlatform >> stackDepth [

	| depth current |
	depth := 0.
	current := thisContext.
	[ current isNil ] whileFalse: [
		current := current sender.
		depth := depth + 1 ].
	^ depth - 1
]

{ #category : #processes }
GRPharoPlatform >> terminateProcess: aProcess [
	"Permanently terminate the process, unwinding first to execute #ensure: and #ifCurtailed: blocks."
	aProcess terminate
]

{ #category : #'private-file library' }
GRPharoPlatform >> useByteArrayLiterals [
	"whether ByteArray literals can/should be used"
	| hasSettings |
	hasSettings := Smalltalk at: #PragmaSetting ifAbsent: [ nil ].
	^ hasSettings isNil
		ifTrue: [
			(Smalltalk at: #Preferences)
				valueOfFlag: #compileUseNewCompiler
				ifAbsent: [ false ] ]
		ifFalse: [ false ]
]

{ #category : #factory }
GRPharoPlatform >> weakDictionaryOfSize: aNumber [
	^ IdentityDictionary new: aNumber
]

{ #category : #'file library' }
GRPharoPlatform >> write: aStringOrByteArray toFile: aFileNameString inFolder: aFolderString [
	"writes aStringOrByteArray to a file named aFileNameString in the folder aFolderString"
	| folder stream fullFilePath |
	folder := FileDirectory default directoryNamed: aFolderString.
	fullFilePath := folder fullNameFor: aFileNameString.
	stream := aStringOrByteArray isString
		ifTrue: [		
			(MultiByteFileStream forceNewFileNamed: fullFilePath)
				ascii;
				wantsLineEndConversion: true;
				yourself ]
		ifFalse: [ (FileStream forceNewFileNamed: fullFilePath) binary ].
	[ stream nextPutAll: aStringOrByteArray ]
		ensure: [ stream close ]
]

{ #category : #factory }
GRPharoPlatform >> writeCharacterStreamOn: aString [

	^ GRWorkingWriteStream on: aString
]
