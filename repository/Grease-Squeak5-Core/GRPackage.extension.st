Extension { #name : #GRPackage }

{ #category : #'*grease-squeak5-core' }
GRPackage class >> greaseSqueak5Core [
	^ self new
		name: 'Grease-Squeak5-Core';
		addDependency: 'Grease-Core';
		url: #greaseUrl;
		yourself
]
