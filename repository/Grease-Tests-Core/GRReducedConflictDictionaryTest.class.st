Class {
	#name : #GRReducedConflictDictionaryTest,
	#superclass : #GRDictionaryTest,
	#category : 'Grease-Tests-Core'
}

{ #category : #configuration }
GRReducedConflictDictionaryTest >> collectionClass [
	^ GRPlatform current reducedConflictDictionary
]
