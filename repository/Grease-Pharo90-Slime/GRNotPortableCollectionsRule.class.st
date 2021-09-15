Class {
	#name : #GRNotPortableCollectionsRule,
	#superclass : #GRSlimeTransformationRule,
	#category : 'Grease-Pharo90-Slime'
}

{ #category : #accessing }
GRNotPortableCollectionsRule >> group [
	^ 'Grease Portability'
]

{ #category : #initialization }
GRNotPortableCollectionsRule >> initialize [
	super initialize.
	self rewriteRule
		replace: '`@collection beginsWith: `@subCollection'
			with: '`@collection beginsWithSubCollection: `@subCollection';
		replace: '`@collection endsWith: `@subCollection'
			with: '`@collection endsWithSubCollection: `@subCollection'
]

{ #category : #accessing }
GRNotPortableCollectionsRule >> name [
	^ 'Collections'
]

{ #category : #accessing }
GRNotPortableCollectionsRule >> rationale [
	^ '#beginsWith: and #endsWith: are not portable.'
]
