Extension { #name : #MessageSend }

{ #category : #'*grease-squeak5-core' }
MessageSend >> argumentCount [
	^ selector numArgs - self arguments size
]

{ #category : #'*grease-squeak5-core' }
MessageSend >> valueWithPossibleArguments: anArray [
	"Evaluate the block represented by the receiver.
     If the block requires one argument, use anArg, if it requires more than one,
     fill up the rest with nils."

	^ self valueWithEnoughArguments: anArray
]