/// Druid
library StructSpellsSpellAlpha requires Asl, StructGameClasses, StructGameSpell

	struct SpellAlpha extends Spell
		public static constant integer abilityId = 'A0FE'
		public static constant integer favouriteAbilityId = 'A0FG'
		public static constant integer classSelectionAbilityId = 'A03M'
		public static constant integer classSelectionGrimoireAbilityId = 'A03Y'
		public static constant integer maxLevel = 1
		/// This ability is added to the animal form if this spell is learned.
		public static constant integer castAbilityId = 'A0FF'

		public static method create takes Character character returns thistype
			local thistype this = thistype.allocate(character, Classes.druid(), Spell.spellTypeUltimate0, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, 0, 0)
			call this.addGrimoireEntry('A03M', 'A03Y')
			call this.addGrimoireEntry('A0FH', 'A0FI')
			
			call this.setIsPassive(true)
			
			return this
		endmethod
	endstruct

endlibrary