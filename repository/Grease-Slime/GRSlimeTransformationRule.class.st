Class {
	#name : #GRSlimeTransformationRule,
	#superclass : #RBTransformationRule,
	#category : 'Grease-Slime'
}

{ #category : #testing }
GRSlimeTransformationRule class >> isVisible [
	^ self name ~= #GRSlimeTransformationRule
]
