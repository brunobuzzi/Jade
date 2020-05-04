"Filed out from Dolphin Smalltalk 7"!

JadePreferenceObject subclass: #JadeRewriteToolPreference
	instanceVariableNames: 'formatterClass'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
JadeRewriteToolPreference guid: (GUID fromString: '{861d340d-b09d-41d9-b7a0-70625e35ca6c}')!
JadeRewriteToolPreference comment: ''!
!JadeRewriteToolPreference categoriesForClass!Unclassified! !
!JadeRewriteToolPreference methodsFor!

displayString

	^'Rewrite Tool Options'!

formatterClass
	^formatterClass!

formatterClass: anObject
	formatterClass := anObject!

initialize

	super initialize.

	formatterClass := 'RBFormatter'.!

publishedAspects
	"Answer a <LookupTable> of the <Aspect>s published by the receiver."

	| aspects |
	aspects := super publishedAspects.
	aspects
		add: (Aspect choice: #formatterClass from: (Array with: 'RBFormatter' with: 'RBConfigurableFormatter')).
	^aspects! !
!JadeRewriteToolPreference categoriesFor: #displayString!public! !
!JadeRewriteToolPreference categoriesFor: #formatterClass!accessing!private! !
!JadeRewriteToolPreference categoriesFor: #formatterClass:!accessing!private! !
!JadeRewriteToolPreference categoriesFor: #initialize!public! !
!JadeRewriteToolPreference categoriesFor: #publishedAspects!public! !

