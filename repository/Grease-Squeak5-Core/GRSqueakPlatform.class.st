Class {
	#name : #GRSqueakPlatform,
	#superclass : #GRPharoPlatform,
	#category : 'Grease-Squeak5-Core'
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

{ #category : #'as yet unclassified' }
GRSqueakPlatform >> readFileStreamOn: aString do: aBlock binary: aBoolean [
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
GRSqueakPlatform >> write: aStringOrByteArray toFile: aFileNameString inFolder: aFolderString [ 
	| folder fullFilePath |
	fullFilePath := FileDirectory default fullNameFor: aFolderString.
	folder := FileDirectory on: fullFilePath.
	(folder fileExists: aFileNameString)
		ifTrue: [folder deleteFileNamed: aFileNameString].
	^ self
		writeFileStreamOn: (folder / aFileNameString) fullName
		do: [:stream | stream nextPutAll: aStringOrByteArray]
		binary: aStringOrByteArray isString not
]

{ #category : #'as yet unclassified' }
GRSqueakPlatform >> writeFileStreamOn: aString do: aBlock binary: aBoolean [ 
	| stream |
	stream := aBoolean
				ifTrue: [ (MultiByteFileStream fileNamed: aString) ascii; wantsLineEndConversion: true; yourself ]
				ifFalse: [ (FileStream fileNamed: aString) binary ].
	[ aBlock value: stream ]
		ensure: [ stream close ]
]
