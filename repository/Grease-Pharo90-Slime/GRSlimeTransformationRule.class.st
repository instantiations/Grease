Class {
	#name : #GRSlimeTransformationRule,
	#superclass : #RBTransformationRule,
	#category : 'Grease-Pharo90-Slime'
}

{ #category : #testing }
GRSlimeTransformationRule class >> isVisible [
	^ self name ~= #GRSlimeTransformationRule
]
