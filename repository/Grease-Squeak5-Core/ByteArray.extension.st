Extension { #name : #ByteArray }

{ #category : #'*grease-squeak5-core' }
ByteArray >> greaseString [
	"ByteArrays should not automatically be converted to Strings. You should use a GRCodec for this."
	^ self printString
]
