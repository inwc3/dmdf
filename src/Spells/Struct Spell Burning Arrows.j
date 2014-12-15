/// Ranger
library StructSpellsSpellBurningArrows requires Asl, StructGameClasses, StructGameSpell

	struct SpellBurningArrows extends Spell
		public static constant integer abilityId = 'A0GS'
		public static constant integer favouriteAbilityId = 'A0GT'
		public static constant integer maxLevel = 5
		
		public static method create takes Character character returns thistype
			local thistype this = thistype.allocate(character, Classes.ranger(), Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, 0, 0)
			call this.addGrimoireEntry('A0GU', 'A0GZ')
			call this.addGrimoireEntry('A0GV', 'A0H0')
			call this.addGrimoireEntry('A0GW', 'A0H1')
			call this.addGrimoireEntry('A0GX', 'A0H2')
			call this.addGrimoireEntry('A0GY', 'A0H3')
			
			return this
		endmethod
	endstruct

endlibrary