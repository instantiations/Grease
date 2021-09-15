"
I'm a work around for bugs in the Pharo stream classes.
"
Class {
	#name : #GRWorkingWriteStream,
	#superclass : #WriteStream,
	#category : 'Grease-Squeak6-Core'
}

{ #category : #positioning }
GRWorkingWriteStream >> reset [
	self resetToStart
]
