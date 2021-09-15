Class {
	#name : #GRZnUtf8CodecStream,
	#superclass : #GRPharoConverterCodecStream,
	#classVars : [
		'Latin1ToUtf8Encodings',
		'Latin1ToUtf8Map'
	],
	#category : 'Grease-Pharo90-Core'
}

{ #category : #streaming }
GRZnUtf8CodecStream >> nextPutAll: aString [
	"Convert the given string from UTF-8 using the fast path if converting to Latin-1"
	1 to: aString size by: 1 do: [ :index |
		converter nextPut: (aString at: index) toStream: stream ]
]
