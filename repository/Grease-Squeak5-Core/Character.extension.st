Extension { #name : #Character }

{ #category : #'*grease-squeak5-core' }
Character >> greaseInteger [
	"Answer an unicode code point of the receiver."
	^ self charCode
]
