Extension { #name : #GRSmallDictionary }

{ #category : #'*grease-squeak5-core' }
GRSmallDictionary >> customizeExplorerContents [
	^ true
]

{ #category : #'*grease-squeak5-core' }
GRSmallDictionary >> explorerContents [
	| contents |	
	contents := OrderedCollection new.
	self keysAndValuesDo: [ :key :value |
		contents add: (ObjectExplorerWrapper
			with: value
			name: (key printString contractTo: 32)
			model: self) ].
	^ contents
]

{ #category : #'*grease-squeak5-core' }
GRSmallDictionary >> hasContentsInExplorer [
	^ true
]
