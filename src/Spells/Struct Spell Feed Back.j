/// Wizard
library StructSpellsSpellFeedBack requires Asl, StructGameClasses, StructGameSpell

	/**
	 * Rückkopplung.
	 */
	struct SpellFeedBack extends Spell
		public static constant integer abilityId = 'A0VU'
		public static constant integer favouriteAbilityId = 'A0VV'
		public static constant integer maxLevel = 5

		public static method create takes Character character returns thistype
			local thistype this = thistype.allocate(character, Classes.wizard(), Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, 0, 0)
			call this.addGrimoireEntry('A0VW', 'A0W1')
			call this.addGrimoireEntry('A0VX', 'A0W2')
			call this.addGrimoireEntry('A0VY', 'A0W3')
			call this.addGrimoireEntry('A0VZ', 'A0W4')
			call this.addGrimoireEntry('A0W0', 'A0W5')
			
			return this
		endmethod
	endstruct

endlibrary