library StructMapSpellsSpellBookOfMagic requires Asl, StructGameCharacter

	/**
	 * Allows the creation of scrolls with the corresponding resources.
	 */
	struct SpellBookOfMagicScrollOfHex extends ASpell
		public static constant integer abilityId = 'A18M'

		private method condition takes nothing returns boolean
			if (this.character().inventory().hasItemType('I05H') and this.character().inventory().hasItemType('I007')) then
				debug call Print("Success")
				return true
			endif
			
			debug call Print("Fail")
			call this.character().displayMessage(ACharacter.messageTypeError, tr("Benötigte Rohstoffe fehlen."))
			
			return false
		endmethod
		
		private method action takes nothing returns nothing
			call this.character().inventory().removeItemType('I05H')
			call this.character().inventory().removeItemType('I007')
			call Character(this.character()).displayItemAcquired(GetObjectName('I03E'), tr("Hergestellt."))
			call Character(this.character()).giveItem('I03E')
		endmethod

		public static method create takes Character character returns thistype
			return thistype.allocate(character, thistype.abilityId, 0, thistype.condition, thistype.action, EVENT_UNIT_SPELL_CHANNEL)
		endmethod
	endstruct
	
	/**
	 * Allows the creation of scrolls with the corresponding resources.
	 */
	struct SpellBookOfMagicScrollOfNecromancy extends ASpell
		public static constant integer abilityId = 'A18N'

		private method condition takes nothing returns boolean
			if (this.character().inventory().totalItemTypeCharges('I05I') >= 2) then
				debug call Print("Success")
				return true
			endif
			
			debug call Print("Fail")
			call this.character().displayMessage(ACharacter.messageTypeError, tr("Benötigte Rohstoffe fehlen."))
			
			return false
		endmethod
		
		private method action takes nothing returns nothing
			call this.character().inventory().removeItemType('I05I')
			call this.character().inventory().removeItemType('I05I')
			call Character(this.character()).displayItemAcquired(GetObjectName('I02I'), tr("Hergestellt."))
			call Character(this.character()).giveItem('I02I')
		endmethod

		public static method create takes Character character returns thistype
			return thistype.allocate(character, thistype.abilityId, 0, thistype.condition, thistype.action, EVENT_UNIT_SPELL_CHANNEL)
		endmethod
	endstruct
	
	struct SpellBookOfMagicScrollOfHealing extends ASpell
		public static constant integer abilityId = 'A18O'

		private method condition takes nothing returns boolean
			if (this.character().inventory().hasItemType('I00B')) then
				debug call Print("Success")
				return true
			endif
			
			debug call Print("Fail")
			call this.character().displayMessage(ACharacter.messageTypeError, tr("Benötigte Rohstoffe fehlen."))
			
			return false
		endmethod
		
		private method action takes nothing returns nothing
			call this.character().inventory().removeItemType('I00B')
			call Character(this.character()).displayItemAcquired(GetObjectName('I00F'), tr("Hergestellt."))
			call Character(this.character()).giveItem('I00F')
		endmethod

		public static method create takes Character character returns thistype
			return thistype.allocate(character, thistype.abilityId, 0, thistype.condition, thistype.action, EVENT_UNIT_SPELL_CHANNEL)
		endmethod
	endstruct
	
	struct SpellBookOfMagicScrollOfMana extends ASpell
		public static constant integer abilityId = 'A18P'

		private method condition takes nothing returns boolean
			if (this.character().inventory().hasItemType('I00C')) then
				debug call Print("Success")
				return true
			endif
			
			debug call Print("Fail")
			call this.character().displayMessage(ACharacter.messageTypeError, tr("Benötigte Rohstoffe fehlen."))
			
			return false
		endmethod
		
		private method action takes nothing returns nothing
			call this.character().inventory().removeItemType('I00C')
			call Character(this.character()).displayItemAcquired(GetObjectName('I00G'), tr("Hergestellt."))
			call Character(this.character()).giveItem('I00G')
		endmethod

		public static method create takes Character character returns thistype
			return thistype.allocate(character, thistype.abilityId, 0, thistype.condition, thistype.action, EVENT_UNIT_SPELL_CHANNEL)
		endmethod
	endstruct

endlibrary