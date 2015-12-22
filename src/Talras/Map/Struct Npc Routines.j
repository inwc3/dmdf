library StructMapMapNpcRoutines requires StructGameDmdfHashTable, StructGameRoutines, StructMapMapNpcs

	/**
	 * \brief Static struct which stores and initializes all NPC routines for specific NPCs/units.
	 */
	struct NpcRoutines
		private static NpcRoutineWithFacing m_wigberhtTraining
		// Ricman
		private static NpcRoutineWithFacing m_ricmanStands

		// castle
		// Sisgard
		private static ARoutine m_sisgardCastSpellRoutine
		private static NpcRoutineWithFacing m_sisgardStandsNearHerHouse
		private static NpcRoutineWithFacing m_sisgardCastsSpells
		// Agihard
		private static NpcRoutineWithFacing m_agihardStandsNearArena
		// Björn
		private static NpcRoutineWithFacing m_bjoernWorksAtFurs
		private static NpcTalksRoutine m_bjoernTalksToHisWife
		private static NpcTalksRoutine m_bjoernTalksToManfred
		// Björn's wife
		private static NpcRoutineWithFacing m_bjoernsWifeStandsNearFire0
		private static NpcTalksRoutine m_bjoernsWifeTalksToBjoern
		private static NpcRoutineWithFacing m_bjoernsWifeStandsNearFire1
		// Osman
		private static NpcRoutineWithFacing m_osmanPrays0
		private static NpcRoutineWithFacing m_osmanStandsNearDuke
		private static NpcRoutineWithFacing m_osmanPrays1
		// Ferdinand
		private static NpcRoutineWithFacing m_ferdinandStandsInCastle
		private static NpcTalksRoutine m_ferdinandTalksToHeimrich
		// Heimrich
		private static NpcTalksRoutine m_heimrichTalksToMarkward
		private static NpcTalksRoutine m_heimrichTalksToFerdinand
		// Markward
		private static NpcTalksRoutine m_markwardTalksToHeimrich
		private static NpcRoutineWithFacing m_markwardStandsInCastle
		// Wieland
		private static NpcHammerRoutine m_wielandHammers
		private static NpcTalksRoutine m_wielandTalks
		private static AUnitRoutine m_wielandDrinks
		// Irmina
		private static NpcRoutineWithFacing m_irminaMovesTo0
		// Einar
		private static NpcRoutineWithFacing m_einarSells
		private static NpcTalksRoutine m_einarTalks
		private static AUnitRoutine m_einarDrinks

		// village/farm
		// Mathilda
		private static NpcTalksRoutine m_mathildaTalksAtBarn
		private static NpcRoutineWithFacing m_mathildaMovesTo0
		private static NpcTalksRoutine m_mathildaTalks
		private static NpcRoutineWithFacing m_mathildaMovesTo1
		// Lothar
		private static NpcRoutineWithFacing m_lotharSells0
		private static NpcTalksRoutine m_lotharFlirtsWithMathilda
		private static NpcRoutineWithFacing m_lotharSells1
		// Manfred
		private static NpcRoutineWithFacing m_manfredCutsWood
		private static NpcTalksRoutine m_manfredTalksToGuntrich
		private static NpcTalksRoutine m_manfredTalksToBjoern
		// Guntrich
		private static NpcRoutineWithFacing m_guntrichStandsOnClimb0
		private static NpcTalksRoutine m_guntrichTalksToManfred
		private static NpcRoutineWithFacing m_guntrichStandsOnClimb1
		// Ursula
		private static NpcRoutineWithFacing m_ursulaReadsBook
		private static NpcRoutineWithFacing m_ursulaStandsNearFire
		
		// forest
		// Trommon
		private static NpcRoutineWithFacing m_trommonInFrontOfHisHouse
		private static NpcRoutineWithFacing m_trommonStandsInFrontOfHisFire
		private static NpcRoutineWithFacing m_trommonWorksInHisGarden
		// Kuno
		private static NpcRoutineWithFacing m_kunoCutsWood
		private static NpcRoutineWithFacing m_kunoSellsWood
		private static NpcTalksRoutine m_kunoTalksToHisDaughter
		// Kuno's daughter
		private static NpcRoutineWithFacing m_kunosDaughterStandsInFrontOfTheHouse
		private static NpcTalksRoutine m_kunosDaughterTalksToKuno

		private static method create takes nothing returns thistype
			return 0
		endmethod

		private method onDestroy takes nothing returns nothing
		endmethod
		
		private static method sisgardCastSpellEndAction takes NpcRoutineWithFacing period returns nothing
			call ResetUnitAnimation(period.unit())
		endmethod

		private static method sisgardCastSpellTargetAction takes NpcRoutineWithFacing period returns nothing
			call SetUnitFacing(period.unit(), period.facing())
			call QueueUnitAnimation(period.unit(), "Spell")
			call TriggerSleepAction(1.267)
			call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Human\\DispelMagic\\DispelMagicTarget.mdl", period.unit(), "chest"))
			call PlaySoundOnUnitBJ(gg_snd_DispelMagicTarget, 100.0, period.unit())
			call TriggerSleepAction(1.0)
			if (not IsUnitPaused(period.unit())) then
				call SetUnitFacing(period.unit(), period.facing())
				call QueueUnitAnimation(period.unit(), "Spell")
				call TriggerSleepAction(1.267)
				call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Human\\DispelMagic\\DispelMagicTarget.mdl", GetRectCenterX(gg_rct_waypoint_sisgard_spell_0), GetRectCenterY(gg_rct_waypoint_sisgard_spell_0)))
				call PlaySoundOnUnitBJ(gg_snd_DispelMagicTarget, 100.0, period.unit())
				call TriggerSleepAction(1.0)
			endif
			if (not IsUnitPaused(period.unit())) then
				call SetUnitFacing(period.unit(), period.facing())
				call QueueUnitAnimation(period.unit(), "Spell")
				call TriggerSleepAction(1.267)
				call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Human\\DispelMagic\\DispelMagicTarget.mdl", GetRectCenterX(gg_rct_waypoint_sisgard_spell_1), GetRectCenterY(gg_rct_waypoint_sisgard_spell_1)))
				call PlaySoundOnUnitBJ(gg_snd_DispelMagicTarget, 100.0, period.unit())
				call TriggerSleepAction(1.0)
			endif
			if (not IsUnitPaused(period.unit())) then
				call SetUnitFacing(period.unit(), period.facing())
				call QueueUnitAnimation(period.unit(), "Spell")
				call TriggerSleepAction(1.267)
				call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Human\\DispelMagic\\DispelMagicTarget.mdl", GetRectCenterX(gg_rct_waypoint_sisgard_spell_2), GetRectCenterY(gg_rct_waypoint_sisgard_spell_2)))
				call PlaySoundOnUnitBJ(gg_snd_DispelMagicTarget, 100.0, period.unit())
			endif
			call TriggerSleepAction(12.0)
			call AContinueRoutineLoop(period, thistype.sisgardCastSpellTargetAction)
		endmethod

		// NOTE take a look into struct Routines which ARoutinePeriod sub types you have to create and which parameters you could set for them!!!
		public static method init takes nothing returns nothing
			// Wigberht
			set thistype.m_wigberhtTraining = NpcRoutineWithFacing.create(Routines.train(), Npcs.wigberht(), 18.00, 5.00, gg_rct_waypoint_wigberht_training)
			call thistype.m_wigberhtTraining.setFacing(252.39)
			
			// Ricman
			set thistype.m_ricmanStands = NpcRoutineWithFacing.create(Routines.moveTo(), Npcs.ricman(), 0.0, 23.59, gg_rct_waypoint_ricman)
			call thistype.m_ricmanStands.setFacing(353.10)

			// Sisgard
			set thistype.m_sisgardStandsNearHerHouse = NpcRoutineWithFacing.create(Routines.moveTo(), Npcs.sisgard(), MapData.evening, MapData.midday, gg_rct_waypoint_sisgard_0)
			call thistype.m_sisgardStandsNearHerHouse.setFacing(211.35)
			set thistype.m_sisgardCastSpellRoutine = ARoutine.create(true, true, 0, 0, thistype.sisgardCastSpellEndAction, thistype.sisgardCastSpellTargetAction)
			set thistype.m_sisgardCastsSpells = NpcRoutineWithFacing.create(thistype.m_sisgardCastSpellRoutine, Npcs.sisgard(), MapData.midday, MapData.evening, gg_rct_waypoint_sisgard_1)
			call thistype.m_sisgardCastsSpells.setFacing(95.26)

			// Agihard
			set thistype.m_agihardStandsNearArena = NpcRoutineWithFacing.create(Routines.moveTo(), Npcs.agihard(), 0.0, 23.59, gg_rct_waypoint_agihard_0)
			call thistype.m_agihardStandsNearArena.setFacing(13.80)

			// Björn
			set thistype.m_bjoernWorksAtFurs = NpcRoutineWithFacing.create(Routines.moveTo(), Npcs.bjoern(), MapData.evening, 14.00, gg_rct_waypoint_bjoern_1)
			call thistype.m_bjoernWorksAtFurs.setFacing(35.48)
			set thistype.m_bjoernTalksToHisWife = NpcTalksRoutine.create(Routines.talk(), Npcs.bjoern(), 14.00, 16.00, gg_rct_waypoint_bjoern_2)
			call thistype.m_bjoernTalksToHisWife.setPartner(Npcs.bjoernsWife())
			call thistype.m_bjoernTalksToHisWife.addSound(tre("Ja mein Lord!", "Yes my lord!"), gg_snd_PeasantWhat1)
			call thistype.m_bjoernTalksToHisWife.addSound(tre("Was ist?", "What is it?"), gg_snd_PeasantWhat2)
			call thistype.m_bjoernTalksToHisWife.addSound(tre("Mehr Arbeit?", "More work?"), gg_snd_PeasantWhat3)
			call thistype.m_bjoernTalksToHisWife.addSound(tre("Was?", "What?"), gg_snd_PeasantWhat4)
			set thistype.m_bjoernTalksToManfred = NpcTalksRoutine.create(Routines.talk(), Npcs.bjoern(), 16.00, MapData.evening, gg_rct_waypoint_bjoern_3)
			call thistype.m_bjoernTalksToManfred.setPartner(Npcs.manfred())

			// Björn's wife
			set thistype.m_bjoernsWifeStandsNearFire0 = NpcRoutineWithFacing.create(Routines.moveTo(), Npcs.bjoernsWife(), MapData.evening, 14.00, gg_rct_waypoint_bjoerns_wife)
			call thistype.m_bjoernsWifeStandsNearFire0.setFacing(183.27)
			set thistype.m_bjoernsWifeTalksToBjoern = NpcTalksRoutine.create(Routines.talk(), Npcs.bjoernsWife(), 14.00, 16.00, gg_rct_waypoint_bjoerns_wife)
			call thistype.m_bjoernsWifeTalksToBjoern.setPartner(Npcs.bjoern())
			set thistype.m_bjoernsWifeStandsNearFire1 = NpcRoutineWithFacing.create(Routines.moveTo(), Npcs.bjoernsWife(), 16.00, MapData.evening, gg_rct_waypoint_bjoerns_wife)
			call thistype.m_bjoernsWifeStandsNearFire1.setFacing(183.27)

			// Osman
			set thistype.m_osmanPrays0 = NpcRoutineWithFacing.create(Routines.moveTo(), Npcs.osman(), MapData.evening, 13.0, gg_rct_waypoint_osman_0)
			call thistype.m_osmanPrays0.setFacing(180.22)
			set thistype.m_osmanStandsNearDuke = NpcRoutineWithFacing.create(Routines.moveTo(), Npcs.osman(), 13.0, 16.0, gg_rct_waypoint_osman_2) // steht bei Herzog
			call thistype.m_osmanStandsNearDuke.setFacing(154.47)
			set thistype.m_osmanPrays1 = NpcRoutineWithFacing.create(Routines.moveTo(), Npcs.osman(), 16.0, MapData.evening, gg_rct_waypoint_osman_0)
			call thistype.m_osmanPrays1.setFacing(180.22)

			// Ferdinand
			set thistype.m_ferdinandStandsInCastle = NpcRoutineWithFacing.create(Routines.moveTo(), Npcs.ferdinand(), MapData.evening, 13.00, gg_rct_waypoint_ferdinand_1)
			call thistype.m_ferdinandStandsInCastle.setFacing(191.10)
			set thistype.m_ferdinandTalksToHeimrich = NpcTalksRoutine.create(Routines.talk(), Npcs.ferdinand(), 13.00, MapData.evening, gg_rct_waypoint_ferdinand_2)
			call thistype.m_ferdinandTalksToHeimrich.setPartner(Npcs.heimrich())
			call thistype.m_ferdinandTalksToHeimrich.setFacing(90.0)

			// Heimrich
			set thistype.m_heimrichTalksToMarkward = NpcTalksRoutine.create(Routines.talk(), Npcs.heimrich(), MapData.evening, 13.00, gg_rct_waypoint_heimrich_1)
			call thistype.m_heimrichTalksToMarkward.setPartner(Npcs.markward())
			call thistype.m_heimrichTalksToMarkward.addSound(tre("Was erlaubt sich das einfache Volk?", "Who does the common people think it is?"), gg_snd_Heimrich12)
			call thistype.m_heimrichTalksToMarkward.addSound(tre("Wir müssen uns auf den Krieg vorbereiten.", "We have to prepare ourselves for the war."), gg_snd_Heimrich13)
			call thistype.m_heimrichTalksToMarkward.addSound(tre("Hat Er sich um alles Nötige gekümmert?", "Did he take care of everything necessary?"), gg_snd_Heimrich14)
			call thistype.m_heimrichTalksToMarkward.addSound(tre("Bald werden sie hier einfallen und dann?", "Soon they will come here and then?"), gg_snd_Heimrich15)
			set thistype.m_heimrichTalksToFerdinand = NpcTalksRoutine.create(Routines.talk(), Npcs.heimrich(), 13.00, MapData.evening, gg_rct_waypoint_heimrich_1)
			call thistype.m_heimrichTalksToFerdinand.setPartner(Npcs.ferdinand())
			call thistype.m_heimrichTalksToFerdinand.addSound(tre("Was erlaubt sich das einfache Volk?", "Who does the common people think it is?"), gg_snd_Heimrich12)
			call thistype.m_heimrichTalksToFerdinand.addSound(tre("Wir müssen uns auf den Krieg vorbereiten.", "We have to prepare ourselves for the war."), gg_snd_Heimrich13)
			call thistype.m_heimrichTalksToFerdinand.addSound(tre("Hat Er sich um alles Nötige gekümmert?", "Did he take care of everything necessary?"), gg_snd_Heimrich14)
			call thistype.m_heimrichTalksToFerdinand.addSound(tre("Bald werden sie hier einfallen und dann?", "Soon they will come here and then?"), gg_snd_Heimrich15)
			set thistype.m_heimrichTalksToFerdinand = NpcTalksRoutine.create(Routines.talk(), Npcs.heimrich(), 13.00, MapData.evening, gg_rct_waypoint_heimrich_1)

			// Markward
			set thistype.m_markwardTalksToHeimrich = NpcTalksRoutine.create(Routines.talk(), Npcs.markward(), MapData.evening, 13.00, gg_rct_waypoint_markward_1)
			call thistype.m_markwardTalksToHeimrich.setPartner(Npcs.heimrich())
			set thistype.m_markwardStandsInCastle = NpcRoutineWithFacing.create(Routines.moveTo(), Npcs.markward(), 13.00, MapData.evening, gg_rct_waypoint_markward_1)
			call thistype.m_markwardStandsInCastle.setFacing(248.05)

			// Wieland
			set thistype.m_wielandHammers = NpcHammerRoutine.create(Routines.hammer(), Npcs.wieland(), MapData.evening, 13.00, gg_rct_waypoint_wieland_0)
			call thistype.m_wielandHammers.setFacing(90.0)
			call thistype.m_wielandHammers.setSound(gg_snd_BlacksmithWhat1)
			call thistype.m_wielandHammers.setSoundVolume(30.0)
			set thistype.m_wielandTalks = NpcTalksRoutine.create(Routines.talk(), Npcs.wieland(), 13.00, MapData.evening, gg_rct_waypoint_wieland_1)
			call thistype.m_wielandTalks.setPartner(Npcs.einar())
			call thistype.m_wielandTalks.setFacing(203.95)
			call thistype.m_wielandTalks.addSound(tre("Wie viele Waffen brauchst du denn?", "How many weapons do you need?"), gg_snd_Wieland38)
			call thistype.m_wielandTalks.addSound(tre("Bei der Bezahlung kann ich meine Schmiede auch gleich schließen.", "Considering this paying I could close my forge just now."), gg_snd_Wieland39)
			call thistype.m_wielandTalks.addSound(tre("Einar, du verdammter Hundesohn!", "Einar, you goddamn bastard!"), gg_snd_Wieland40)
			call thistype.m_wielandTalks.addSound(tre("Hör mir auf mit den Orks!", "Stop with those Orcs!"), gg_snd_Wieland41)
			//set thistype.m_wielandDrinks = NpcRoutineWithFacing.create(Routines.drink(), Npcs.wieland(), 14.00, MapData.evening, gg_rct_waypoint_wieland_2)
			
			// Mathilda
			set thistype.m_mathildaTalksAtBarn = NpcTalksRoutine.create(Routines.moveTo(), Npcs.mathilda(), MapData.evening, MapData.morning, gg_rct_waypoint_mathilda_1)
			call thistype.m_mathildaTalksAtBarn.setPartner(gg_unit_n02J_0013)
			call thistype.m_mathildaTalksAtBarn.setFacing(118.56)
			set thistype.m_mathildaMovesTo0 = NpcRoutineWithFacing.create(Routines.moveTo(), Npcs.mathilda(), MapData.morning, 13.00, gg_rct_waypoint_mathilda_0)
			call thistype.m_mathildaMovesTo0.setFacing(74.69)
			set thistype.m_mathildaTalks = NpcTalksRoutine.create(Routines.talk(), Npcs.mathilda(), 13.00, 16.00, gg_rct_waypoint_mathilda_0)
			call thistype.m_mathildaTalks.setPartner(Npcs.lothar())
			call thistype.m_mathildaTalks.setFacing(74.69)
			set thistype.m_mathildaMovesTo1 = NpcRoutineWithFacing.create(Routines.moveTo(), Npcs.mathilda(), 16.00, MapData.evening, gg_rct_waypoint_mathilda_0)
			call thistype.m_mathildaMovesTo1.setFacing(74.69)

			// Lothar
			set thistype.m_lotharSells0 = NpcRoutineWithFacing.create(Routines.moveTo(), Npcs.lothar(), MapData.evening, 13.00, gg_rct_waypoint_lothar_0)
			call thistype.m_lotharSells0.setFacing(93.32)
			set thistype.m_lotharFlirtsWithMathilda = NpcTalksRoutine.create(Routines.talk(), Npcs.lothar(), 13.00, 16.00, gg_rct_waypoint_lothar_1)
			call thistype.m_lotharFlirtsWithMathilda.setPartner(Npcs.mathilda())
			call thistype.m_lotharFlirtsWithMathilda.setFacing(180.0)
			// NOTE he cannot say this to her, he is to shy as he says in the talk
			//call thistype.m_lotharFlirtsWithMathilda.addSound(tre("Oh du Liebe meines Lebens!", "Oh you love of my life!"), gg_snd_Lothar55)
			call thistype.m_lotharFlirtsWithMathilda.addSound(tre("Möchtest du von meinem Honig kosten?", "Would you like to taste from my honey?"), gg_snd_Lothar56)
			call thistype.m_lotharFlirtsWithMathilda.addSound(tre("Mathilda, oh du holde, Schöne, spiele mir ein Lied!", "Mathilda, oh you sweet, beautiful, play a song for me!"), gg_snd_Lothar57)
			call thistype.m_lotharFlirtsWithMathilda.addSound(tre("Willst du mir nicht eine deiner wunderbaren Geschichten erzählen?", "Don't you want to tell me one of your wonderful stories?"), gg_snd_Lothar58)
			call thistype.m_lotharFlirtsWithMathilda.addSound(tre("Koste von meinem Wein, oh du liebliches Wesen!", "Taste from my wine, oh you lovely creature!"), gg_snd_Lothar59)
			// TODO add missing sentences
			set thistype.m_lotharSells1 = NpcRoutineWithFacing.create(Routines.moveTo(), Npcs.lothar(), 16.00, MapData.evening, gg_rct_waypoint_lothar_0)
			call thistype.m_lotharSells1.setFacing(93.32)

			// Irmina
			set thistype.m_irminaMovesTo0 = NpcRoutineWithFacing.create(Routines.moveTo(), Npcs.irmina(), 0.0, 23.59, gg_rct_waypoint_irmina_1) // sell
			call thistype.m_irminaMovesTo0.setFacing(16.01)

			// Einar
			set thistype.m_einarSells = NpcRoutineWithFacing.create(Routines.moveTo(), Npcs.einar(), MapData.evening, 13.00, gg_rct_waypoint_einar_1) // sell
			call thistype.m_einarSells.setFacing(35.83)
			set thistype.m_einarTalks = NpcTalksRoutine.create(Routines.talk(), Npcs.einar(), 13.00, MapData.evening, gg_rct_waypoint_einar_1) // talk to Wieland
			call thistype.m_einarTalks.setPartner(Npcs.wieland())
			//set thistype.m_einarDrinks = NpcRoutineWithFacing.create(Routines.drink(), Npcs.einar(), 14.00, MapData.evening, gg_rct_waypoint_einar_2) // drinks with Wieland in tavern

			// Manfred
			set thistype.m_manfredCutsWood = NpcRoutineWithFacing.create(Routines.splitWood(), Npcs.manfred(), MapData.evening, MapData.midday, gg_rct_waypoint_manfred_2)
			call thistype.m_manfredCutsWood.setFacing(279.37)
			set thistype.m_manfredTalksToGuntrich = NpcTalksRoutine.create(Routines.talk(), Npcs.manfred(), MapData.midday, 16.00, gg_rct_waypoint_manfred_3)
			call thistype.m_manfredTalksToGuntrich.setPartner(Npcs.guntrich())
			set thistype.m_manfredTalksToBjoern = NpcTalksRoutine.create(Routines.talk(), Npcs.manfred(), 16.00, MapData.evening, gg_rct_waypoint_manfred_1)
			call thistype.m_manfredTalksToBjoern.setPartner(Npcs.bjoern())
			call thistype.m_manfredTalksToBjoern.addSound(tre("Ja mein Lord!", "Yes my Lord!"), gg_snd_PeasantWhat1)
			call thistype.m_manfredTalksToBjoern.addSound(tre("Was ist?", "What is it?"), gg_snd_PeasantWhat2)
			call thistype.m_manfredTalksToBjoern.addSound(tre("Mehr Arbeit?", "More work?"), gg_snd_PeasantWhat3)
			call thistype.m_manfredTalksToBjoern.addSound(tre("Was?", "Yes?"), gg_snd_PeasantWhat4)

			// Guntrich
			set thistype.m_guntrichStandsOnClimb0 = NpcRoutineWithFacing.create(Routines.moveTo(), Npcs.guntrich(), MapData.evening, MapData.midday, gg_rct_waypoint_guntrich_1)
			call thistype.m_guntrichStandsOnClimb0.setFacing(231.25)
			set thistype.m_guntrichTalksToManfred = NpcTalksRoutine.create(Routines.talk(), Npcs.guntrich(), MapData.midday, 16.00, gg_rct_waypoint_guntrich_2)
			call thistype.m_guntrichTalksToManfred.setPartner(Npcs.manfred())
			set thistype.m_guntrichStandsOnClimb1 = NpcRoutineWithFacing.create(Routines.moveTo(), Npcs.guntrich(), 16.00, MapData.evening, gg_rct_waypoint_guntrich_1)
			call thistype.m_guntrichStandsOnClimb1.setFacing(231.25)

			// Ursula
			set thistype.m_ursulaReadsBook = NpcRoutineWithFacing.create(Routines.moveTo(), Npcs.ursula(), MapData.evening, MapData.midday, gg_rct_waypoint_ursula_1)
			call thistype.m_ursulaReadsBook.setFacing(73.58)
			set thistype.m_ursulaStandsNearFire = NpcRoutineWithFacing.create(Routines.moveTo(), Npcs.ursula(), MapData.midday, MapData.evening, gg_rct_waypoint_ursula_2)
			call thistype.m_ursulaStandsNearFire.setFacing(20.67)
			
			// forest
			// Trommon
			set thistype.m_trommonInFrontOfHisHouse = NpcRoutineWithFacing.create(Routines.moveTo(), Npcs.trommon(), MapData.evening, MapData.midday, gg_rct_waypoint_trommon_0)
			call thistype.m_trommonInFrontOfHisHouse.setFacing(89.65)
			set thistype.m_trommonStandsInFrontOfHisFire = NpcRoutineWithFacing.create(Routines.moveTo(), Npcs.trommon(), MapData.midday, 14.0, gg_rct_waypoint_trommon_1)
			call thistype.m_trommonStandsInFrontOfHisFire.setFacing(153.48)
			set thistype.m_trommonWorksInHisGarden = NpcRoutineWithFacing.create(Routines.splitWood(), Npcs.trommon(), 14.0, MapData.evening, gg_rct_waypoint_trommon_2)
			call thistype.m_trommonWorksInHisGarden.setFacing(235.02)
			
			// Kuno
			set thistype.m_kunoCutsWood = NpcRoutineWithFacing.create(Routines.splitWood(), Npcs.kuno(), MapData.evening, MapData.midday, gg_rct_waypoint_kuno_4)
			call thistype.m_kunoCutsWood.setFacing(0.0)
			set thistype.m_kunoSellsWood = NpcRoutineWithFacing.create(Routines.moveTo(), Npcs.kuno(), MapData.midday, 16.0, gg_rct_waypoint_kuno_3)
			call thistype.m_kunoSellsWood.setFacing(276.32)
			set thistype.m_kunoTalksToHisDaughter = NpcTalksRoutine.create(Routines.talk(), Npcs.kuno(), 16.0, MapData.evening, gg_rct_waypoint_kuno_0)
			call thistype.m_kunoTalksToHisDaughter.setPartner(Npcs.kunosDaughter())
			call thistype.m_kunoTalksToHisDaughter.setFacing(357.00)
			// TODO different stuff
			call thistype.m_kunoTalksToHisDaughter.addSound(tre("Ja mein Lord!", "Yes my Lord!"), gg_snd_PeasantWhat1)
			call thistype.m_kunoTalksToHisDaughter.addSound(tre("Was ist?", "What is it?"), gg_snd_PeasantWhat2)
			call thistype.m_kunoTalksToHisDaughter.addSound(tre("Mehr Arbeit?", "More work?"), gg_snd_PeasantWhat3)
			call thistype.m_kunoTalksToHisDaughter.addSound(tre("Was?", "Yes?"), gg_snd_PeasantWhat4)
			
			// Kuno's daughter
			set thistype.m_kunosDaughterStandsInFrontOfTheHouse = NpcRoutineWithFacing.create(Routines.moveTo(), Npcs.kunosDaughter(), MapData.evening, 16.0, gg_rct_waypoint_kunos_daughter_1)
			call thistype.m_kunosDaughterStandsInFrontOfTheHouse.setFacing(272.23)
			set thistype.m_kunosDaughterTalksToKuno = NpcTalksRoutine.create(Routines.talk(), Npcs.kunosDaughter(), 16.0, MapData.evening, gg_rct_waypoint_kunos_daughter_0)
			call thistype.m_kunosDaughterTalksToKuno.setPartner(Npcs.kuno())
			call thistype.m_kunosDaughterTalksToKuno.setFacing(35.21)

			// menials
			call NpcRoutineWithFacing.create(Routines.harvest(), gg_unit_n02J_0013, MapData.morning, MapData.evening, gg_rct_waypoint_menial_0)
			call AUnitRoutine.create(Routines.moveTo(), gg_unit_n02J_0013, MapData.evening, MapData.morning, gg_rct_waypoint_menials_sleep)
			call NpcRoutineWithFacing.create(Routines.harvest(), gg_unit_n02J_0157, MapData.morning, MapData.evening, gg_rct_waypoint_menial_1)
			call AUnitRoutine.create(Routines.moveTo(), gg_unit_n02J_0157, MapData.evening, MapData.morning, gg_rct_waypoint_menials_sleep)
			call NpcRoutineWithFacing.create(Routines.harvest(), gg_unit_n02J_0159, MapData.morning, MapData.evening, gg_rct_waypoint_menial_2)
			call AUnitRoutine.create(Routines.moveTo(), gg_unit_n02J_0159, MapData.evening, MapData.morning, gg_rct_waypoint_menials_sleep)
			call NpcRoutineWithFacing.create(Routines.harvest(), gg_unit_n02J_0158, MapData.morning, MapData.evening, gg_rct_waypoint_menial_3)
			call AUnitRoutine.create(Routines.moveTo(), gg_unit_n02J_0158, MapData.evening, MapData.morning, gg_rct_waypoint_menials_sleep)
		endmethod

		// NOTE manual start ALL!
		public static method manualStart takes nothing returns nothing
			call AUnitRoutine.manualStart(Npcs.wigberht())
			call AUnitRoutine.manualStart(Npcs.sisgard())
			call AUnitRoutine.manualStart(Npcs.agihard())
			call AUnitRoutine.manualStart(Npcs.bjoern())
			call AUnitRoutine.manualStart(Npcs.bjoernsWife())
			call AUnitRoutine.manualStart(Npcs.osman())
			call AUnitRoutine.manualStart(Npcs.ferdinand())
			call AUnitRoutine.manualStart(Npcs.heimrich())
			call AUnitRoutine.manualStart(Npcs.markward())
			call AUnitRoutine.manualStart(Npcs.wieland())
			call AUnitRoutine.manualStart(Npcs.irmina())
			call AUnitRoutine.manualStart(Npcs.einar())
			call AUnitRoutine.manualStart(Npcs.mathilda())
			call AUnitRoutine.manualStart(Npcs.lothar())
			call AUnitRoutine.manualStart(Npcs.kuno())
			call AUnitRoutine.manualStart(Npcs.kunosDaughter())
			call AUnitRoutine.manualStart(Npcs.trommon())
			call AUnitRoutine.manualStart(gg_unit_n02J_0013)
			call AUnitRoutine.manualStart(gg_unit_n02J_0157)
			call AUnitRoutine.manualStart(gg_unit_n02J_0159)
			call AUnitRoutine.manualStart(gg_unit_n02J_0158)
		endmethod
	endstruct

endlibrary