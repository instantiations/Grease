Extension { #name : #GRPlatformTest }

{ #category : #'*grease-tests-squeak6-core' }
GRPlatformTest >> testScaledDecimalGreaseString [
	self assert: 123.4s1 greaseString = '123.4'.
	self assert: 123.4s2 greaseString = '123.40'.
	self assert: 123s0 greaseString = '123'
]