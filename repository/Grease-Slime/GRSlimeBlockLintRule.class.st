Class {
	#name : #GRSlimeBlockLintRule,
	#superclass : #RBBlockLintRule,
	#category : 'Grease-Slime'
}

{ #category : #testing }
GRSlimeBlockLintRule class >> isVisible [
	^ self name ~= #GRSlimeBlockLintRule
]

{ #category : #accessing }
GRSlimeBlockLintRule >> category [
	^ self group
]
