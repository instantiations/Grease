Extension { #name : #SequenceableCollection }

{ #category : #'*grease-gemstone-core' }
SequenceableCollection >> beginsWithSubCollection: aSequenceableCollection [
	"Some platforms implement #beginsWith: to answer true for an empty argument."
	
	aSequenceableCollection isEmpty ifTrue: [ ^false ].
	^ self beginsWith: aSequenceableCollection
]

{ #category : #'*grease-gemstone-core' }
SequenceableCollection >> endsWithSubCollection: aSequenceableCollection [
	"Some platforms implement #endsWith: to answer true for an empty argument."	
	
	^ self endsWith: aSequenceableCollection
]
