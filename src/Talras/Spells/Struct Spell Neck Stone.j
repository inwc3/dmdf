/// Item
library StructMapSpellsSpellNeckStone requires Asl, StructGameClasses, StructMapMapAos, StructSpellsSpellMetamorphosis

	struct SpellNeckStone extends SpellMetamorphosis

		// Called with .evaluate()
		public stub method canMorph takes nothing returns boolean
			return true
		endmethod
		
		/// Called after unit has morphed.
		public stub method onMorph takes nothing returns nothing
		endmethod
		
		public stub method canRestore takes nothing returns boolean
			if (not IsTerrainPathable(GetUnitX(this.character().unit()), GetUnitY(this.character().unit()), PATHING_TYPE_WALKABILITY)) then
				call this.character().displayMessage(ACharacter.messageTypeError, tr("Charakter muss sich außerhalb des Wassers befinden."))
			
				return false
			endif
			
			return true
		endmethod
		
		/// Called after unit has been restored.
		public stub method onRestore takes nothing returns nothing
		endmethod

		public static method create takes Character character, integer abilityId, integer morphAbiliyId, integer unmorphAbilityId returns thistype
			local thistype this = thistype.allocate(character, abilityId, morphAbiliyId, unmorphAbilityId)
			call this.setDisableGrimoire(false)
			
			return this
		endmethod
		
		public method onDestroy takes nothing returns nothing
		endmethod
	endstruct

endlibrary