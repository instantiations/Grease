Extension { #name : #SequenceableCollection }

{ #category : #'*grease-squeak5-core' }
SequenceableCollection >> beginsWithSubCollection: aSequenceableCollection [
	"Some platforms implement #beginsWith: to answer true for an empty argument."
	^ self beginsWith: aSequenceableCollection
]

{ #category : #'*grease-squeak5-core' }
SequenceableCollection >> endsWithSubCollection: aSequenceableCollection [
	"Some platforms implement #endsWith: to answer true for an empty argument."
	^ self endsWith: aSequenceableCollection
]

{ #category : #'*grease-squeak5-core' }
SequenceableCollection >> sorted [
	^ self sorted: [ :a :b | a <= b ]
]
