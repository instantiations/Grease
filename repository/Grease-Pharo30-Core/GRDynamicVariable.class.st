"
I represent a dynamic variable i.e., a variable that is
1. process local, that
2. is defined for a given block and that
3. can be nested.

For example:

GRDynamicVariable
	use: 1
	during: [
		self assert: GRDynamicVariable value = 1.
		GRDynamicVariable
			use: 2
			during: [ self assert: GRDynamicVariable value = 2 ].
		self assert: GRDynamicVariable value = 1 ].
"
Class {
	#name : #GRDynamicVariable,
	#superclass : #DynamicVariable,
	#category : 'Grease-Pharo30-Core'
}

{ #category : #accessing }
GRDynamicVariable class >> defaultValue [
	^ nil
]

{ #category : #accessing }
GRDynamicVariable class >> use: anObject during: aBlock [
	^ self
		value: anObject
		during: aBlock
]

{ #category : #accessing }
GRDynamicVariable >> default [
	^ self class defaultValue
]

{ #category : #accessing }
GRDynamicVariable >> value: anObject during: aBlock [
	| p oldValue |
	p := Processor activeProcess.
	oldValue := p psValueAt: index.
	^ [ 
		p psValueAt: index put: anObject.
		aBlock value ] ensure: [ p psValueAt: index put: oldValue ] 
]
