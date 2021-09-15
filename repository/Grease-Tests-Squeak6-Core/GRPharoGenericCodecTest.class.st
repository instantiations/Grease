Class {
	#name : #GRPharoGenericCodecTest,
	#superclass : #TestCase,
	#category : 'Grease-Tests-Squeak6-Core'
}

{ #category : #tests }
GRPharoGenericCodecTest >> testNoAmbiguities [
	#('utf-8' 'UTF-8' 'utf8') do: [ :each |
		self deny: (GRPharoGenericCodec supportsEncoding: each) ].
	GRPharoLatin1Codec supportedEncodingNames do: [ :each |
		self deny: (GRPharoGenericCodec supportsEncoding: each) ]
]
