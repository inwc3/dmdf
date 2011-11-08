library StructMapTalksTalkFulco requires Asl, StructGameClasses, StructMapQuestsQuestMyFriendTheBear

	struct TalkFulco extends ATalk

		implement Talk

		private method startPageAction takes nothing returns nothing
			call this.showUntil(4)
		endmethod

		// Hallo Bär.
		private static method infoAction0 takes AInfo info returns nothing
			call speech(info, false, tr("Hallo Bär."), null)
			call speech(info, true, tr("￼Ja ja, mach dich nur lustig über mich! Es ist ja auch so zum Lachen, wenn man aussieht wie ein Bär."), null)
			call speech(info, false, tr("Allerdings."), null)
			call info.talk().showRange(5, 6)
		endmethod

		// (Auftrag „Mein Freund der Bär“ abgeschlossen)
		private static method infoCondition1 takes AInfo info returns boolean
			return QuestMyFriendTheBear.characterQuest(info.talk().character()).isCompleted()
		endmethod

		// Ich habe gehört, du hast Tellborn einige Zutaten für seinen Trank besorgt
		private static method infoAction1 takes AInfo info returns nothing
			call speech(info, true, tr("Ich habe gehört, du hast Tellborn einige Zutaten für seinen Trank besorgt"), null)
			call speech(info, true, tr("Ich danke dir vielmals. Bald werde ich wieder aussehen wie ein Mensch! Hier hast du ein paar Gegenstände."), null)
			// Charakter erhält 3 Manatränke und 1 Ring der Verborgenheit.
			/// @todo Give items!
			call info.talk().showStartPage()
		endmethod

		// Du siehst aus wie ein Magier.
		private static method infoAction2 takes AInfo info returns nothing
			call speech(info, false, tr("Du siehst aus wie ein Magier."), null)
			call speech(info, true, tr("￼￼Zauberer, wenn ich bitten darf. Das ist die korrekte Bezeichnung. Ich bin nicht irgendein Hokuspokusmöchtegernmagier, der Feuerbälle auf seine Feinde wirft. Ich suche nach Wissen."), null)
			// (Charakter ist Zauberer)
			if (info.talk().character().class() == Classes.wizard()) then
				call speech(info, true, tr("Das solltest du selbst aber am besten wissen."), null)
			endif
			call info.talk().showStartPage()
		endmethod
		
		//  (Nach der Feststellung, dass Fulco ein Zauberer ist)
		private static method infoCondition3 takes AInfo info returns boolean
			return info.talk().infoHasBeenShown(2)
		endmethod

		// ￼Meine Zauberkraft ist fast erloschen!
		private static method infoAction3 takes AInfo info returns nothing
			call speech(info, false, tr("￼Meine Zauberkraft ist fast erloschen!"), null)
			// Fulco macht Bewegungen.
			/// @todo Animate with effect!
			call speech(info, true, tr("Da hast du sie wieder."), null)
			// Das Mana des Charakters wird aufgefüllt.
			call SetUnitState(info.talk().character().unit(), UNIT_STATE_MANA, GetUnitState(info.talk().character().unit(), UNIT_STATE_MAX_MANA))
			call info.talk().showStartPage()
		endmethod

		// Was ist passiert?
		private static method infoAction0_1 takes AInfo info returns nothing
			call speech(info, false, tr("Was ist passiert?"), null)
			call speech(info, true, tr("Mein werter Freund Tellborn hat mich geheilt! Zumindest wollte er mich heilen, aber das hat wohl nicht so ganz geklappt."), null)
			call speech(info, true, tr("Kann ja mal passieren, dass man den falschen Zauber anwendet, aber wieso zum Teufel gerade ein Zauber, der mich in einen Bären verwandelt?"), null)
			call speech(info, true, tr("So kann man sich doch nirgendwo mehr blicken lassen ohne gleich gejagt und erschlagen zu werden!"), null)
			call info.talk().showStartPage()
		endmethod

		private static method create takes nothing returns thistype
			local thistype this = thistype.allocate(gg_unit_n012_0115, thistype.startPageAction)

			// start page
			call this.addInfo(false, false, 0, thistype.infoAction0, tr("Hallo Bär.")) // 0
			call this.addInfo(false, true, thistype.infoCondition1, thistype.infoAction1, null) // 1
			call this.addInfo(false, false, 0, thistype.infoAction2, tr("￼Du siehst aus wie ein Magier.")) // 2
			call this.addInfo(true, false, thistype.infoCondition3, thistype.infoAction3, tr("Meine Zauberkraft ist fast erloschen!")) // 3
			call this.addExitButton() // 4

			// info 0
			call this.addInfo(false, false, 0, thistype.infoAction0_1, tr("Was ist passiert?")) // 5
			call this.addBackToStartPageButton() // 6

			return this
		endmethod
	endstruct

endlibrary