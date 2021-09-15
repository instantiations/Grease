Extension { #name : #PositionableStream }

{ #category : #'*grease-squeak5-core' }
PositionableStream >> greaseUpToAll: aCollection [ 
	"Needed for Seaside ports to other dialects where #upToAll: may have
	different semantics"
	^ self upToAll: aCollection
]
