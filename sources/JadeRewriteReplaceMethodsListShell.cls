"Filed out from Dolphin Smalltalk 7"!

JadeRewriteMethodsListShell subclass: #JadeRewriteReplaceMethodsListShell
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
JadeRewriteReplaceMethodsListShell guid: (GUID fromString: '{a582417b-62e5-4c66-a984-c0d10965dd06}')!
JadeRewriteReplaceMethodsListShell comment: ''!
!JadeRewriteReplaceMethodsListShell categoriesForClass!Unclassified! !
!JadeRewriteReplaceMethodsListShell methodsFor!

defaultPresenterClass

	^JadeRewriteReplaceMethodsList!

isReplacing

	^parentPresenter isReplacing!

replaceText

	^parentPresenter replaceText! !
!JadeRewriteReplaceMethodsListShell categoriesFor: #defaultPresenterClass!public! !
!JadeRewriteReplaceMethodsListShell categoriesFor: #isReplacing!public! !
!JadeRewriteReplaceMethodsListShell categoriesFor: #replaceText!public! !

!JadeRewriteReplaceMethodsListShell class methodsFor!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 327686 ##(Smalltalk.Color) #default nil 549 nil nil nil 416 1180166 ##(Smalltalk.ProportionalLayout) 170 176 8 #() false 170 192 34 2 410 ##(Smalltalk.ReferenceView) 34 14 nil 416 34 2 8 1140850688 131073 592 nil 480 nil 7 nil nil nil 592 1180230 1 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.JadeRewriteReplaceMethodsList) #resource_Default_view nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 328198 ##(Smalltalk.Point) 1 1 802 1549 863 592 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 6 3 0 0 175 1 0 0] 544 802 193 193 nil 27 8 'rewriteMethodsList' nil 461638 4 ##(Smalltalk.MenuBar) nil true 34 1 265030 4 ##(Smalltalk.Menu) nil true 34 9 984134 2 ##(Smalltalk.CommandMenuItem) 1 1180998 4 ##(Smalltalk.CommandDescription) #removeFromList 8 'Remove from List' 1 1 nil nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 1026 1 1058 #apply 8 'Apply' 1 1 nil nil nil 1026 1 1058 #applyAll 8 'Apply All' 1 1 nil nil nil 1106 4097 1026 1 1058 #rollback 8 'Rollback' 1 1 nil nil nil 1026 1 1058 #rollbackAll 8 'Rollback All' 1 1 nil nil nil 1106 4097 1026 1 1058 #exit 8 'Exit' 1 1 nil nil nil 8 'Operations' nil 134217729 nil nil 49101 nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil nil 1 nil nil nil nil 1 nil nil 690 138 144 34 3 754 #createAt:extent: 34 2 802 2559 21 802 1581 981 416 754 #text: 34 1 8 'Jade Rewrite Methods List' 416 754 #updateMenuBar 544 416 850 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 10 0 0 0 21 8 0 0 244 1 0 0] 34 1 592 896 nil 27 )! !
!JadeRewriteReplaceMethodsListShell class categoriesFor: #resource_Default_view!public!resources-views! !

