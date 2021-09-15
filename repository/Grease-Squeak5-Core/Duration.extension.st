Extension { #name : #Duration }

{ #category : #'*grease-squeak5-core' }
Duration >> asMilliseconds [
	^ self asMilliSeconds
]

{ #category : #'*grease-squeak5-core' }
Duration >> milliseconds [
	^ nanos quo: NanosInMillisecond
]

{ #category : #'*grease-squeak5-core' }
Duration class >> milliseconds: anInteger [
	^ self milliSeconds: anInteger
]
