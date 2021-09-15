Class {
	#name : #GRSqueakPlatform,
	#superclass : #GRPharoPlatform,
	#category : 'Grease-Squeak-Core'
}

{ #category : #'class initialization' }
GRSqueakPlatform class >> initialize [
	super initialize.
	self select
]

{ #category : #'file library' }
GRSqueakPlatform >> defaultDirectoryPathString [
	^ FileDirectory default fullName
]

{ #category : #'file library' }
GRSqueakPlatform >> deleteFile: aFileName inFolder: aPathString [ 
	(FileDirectory on: aPathString)
		deleteFileNamed: aFileName
]

{ #category : #'file library' }
GRSqueakPlatform >> directoriesIn: aPathString [
	"Return a collection of absolute paths for all the files (no directories) in the directory given by aPathString
	must not include file names that start with ."
	| directory |
	directory := FileDirectory default directoryNamed: aPathString.
	^ (directory directoryNames
		reject: [ :each | each first = $. ])
		collect: [ :each | directory fullNameFor: each ]
]

{ #category : #private }
GRSqueakPlatform >> doSilently: aBlock [
	^SystemChangeNotifier uniqueInstance doSilently: aBlock
]

{ #category : #'file library' }
GRSqueakPlatform >> ensureExistenceOfFolder: aString [
	^FileDirectory default assureExistenceOfPath: aString
]

{ #category : #'file library' }
GRSqueakPlatform >> fileExists: aString [
	^FileDirectory default fileExists: aString
]

{ #category : #'file library' }
GRSqueakPlatform >> fileNameFor: aPathString [
	| path |
	path := FileDirectory default fullPathFor: aPathString.
	^ (path size > 1 and: [ path endsWith: FileDirectory slash ])
		ifTrue: [ path allButLast: FileDirectory slash size ]
		ifFalse: [ path ]
]

{ #category : #'file library' }
GRSqueakPlatform >> fileStreamOn: aString do: aBlock binary: aBoolean [
	^ aBoolean
		ifTrue: [
			FileStream fileNamed: aString do: [ :stream |
				stream binary.
				aBlock value: stream ] ]
		ifFalse: [
			MultiByteFileStream fileNamed: aString do: [ :stream |
				stream
					ascii;
					wantsLineEndConversion: true.
					aBlock value: stream ] ]
]

{ #category : #'file library' }
GRSqueakPlatform >> filesIn: aPathString [
	"Return a collection of absolute paths for all the files (no directories) in the directory given by aPathString
	must not include file names that start with ."
	| directory |
	directory := FileDirectory default directoryNamed: aPathString.
	^ (directory fileNames
		reject: [ :each | each first = $. ])
		collect: [ :each | directory fullNameFor: each ]
]

{ #category : #'file library' }
GRSqueakPlatform >> isDirectory: aPathString [
	^ (FileDirectory forFileName: aPathString) directoryEntry isDirectory
]

{ #category : #'file library' }
GRSqueakPlatform >> localNameOf: aFilename [
	^FileDirectory localNameFor: aFilename
]

{ #category : #'file library' }
GRSqueakPlatform >> pathSeparator [
	^ FileDirectory pathNameDelimiter asString
]

{ #category : #'file library' }
GRSqueakPlatform >> write: aStringOrByteArray toFile: aFileNameString inFolder: aFolderString [
	"writes aStringOrByteArray to a file named aFilenameString in the folder aFolderString"
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
