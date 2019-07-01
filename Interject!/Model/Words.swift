//
//  File.swift
//  Interject!
//
//  Created by Rory Hinnen on 12/2/18.
//  Copyright © 2018 Rory Hinnen. All rights reserved.
//

import Foundation

class Sentence: NSObject, Codable {
    // The sentence. This is our primary structure.
    // perhaps I should include Entry as part of this, rather than
    // a selfcontained structure, but there are times when I want to
    // hand around just an entry without the extra words
    // (like when I'm handing off to meaning)
    // There are two initializers.
    var adjective1: Entry
    var adjective2: Entry
    var noun: Entry
    
    // This initializer will take three Entry vars and assign them into a sentence
    init(adjective1: Entry, adjective2: Entry, noun: Entry) {
        self.adjective1 = adjective1
        self.adjective2 = adjective2
        self.noun = noun
    }
    
    // This initializer will make an empty sentence
    override init() {
        adjective1 = Entry(nsfw: nil, nsfwMeaning: nil, sfw: "", meaning: "")
        adjective2 = Entry(nsfw: nil, nsfwMeaning: nil, sfw: "", meaning: "")
        noun = Entry(nsfw: nil, nsfwMeaning: nil, sfw: "", meaning: "")
    }
}

struct Entry: Codable {
    // The structure of the words themself.
    // a word could be sfw or nsfw,
    // and meanings may also be sfw or nsfw
    // The words are private, and if you query Entry, you will need to
    // provide a bool. The return will be the appropriate word or meaning.
    
    // this structure as no initializer
    fileprivate var nsfw, nsfwMeaning: String?
    fileprivate var sfw, meaning: String
    
    func word(_ isSfw: Bool) -> String {
        var theWord = String()
        if isSfw {
            theWord = sfw
        } else {
            theWord = nsfw ?? sfw
        }
        return theWord
    }
    
    func define(_ isSfw: Bool) -> String {
        var theMeaning = String()
        if isSfw {
            theMeaning = meaning
        } else {
            theMeaning = nsfwMeaning ?? meaning
        }
        return theMeaning
    }
}

// No one should be able to pick just a single word, so we're keeping this to ourselves.
private func pick(list: [Entry]) -> Entry {
    let which = Int(arc4random_uniform(UInt32(list.count)))
    return list[which]
}

func newSentence(oldSentence: Sentence) -> Sentence {
    
    // find adjective one, which could be from the pool of first words or adjectives.
    // remove the current words from the list of possible words
    // pick from the list for just one word.
    let firstList = first + adjectives
    let adj1List = firstList.filter({$0.word(true) != oldSentence.adjective1.word(true)}).filter({$0.word(true) != oldSentence.adjective2.word(true)})
    let firstAdj = pick(list: adj1List)
    
    // find adjective two, only from the pool of adjectives
    // remove current words and adjective one from the pool
    // pick from the list for just one word
    let adj2List = adjectives.filter({$0.word(true) != oldSentence.adjective1.word(true)}).filter({$0.word(true) != oldSentence.adjective2.word(true)}).filter({$0.word(true) != firstAdj.word(true)})
    let adjective2 = pick(list: adj2List)
    
    // find the noun, only from the pool of nouns
    // remove the current word from the pool
    // select the new noun.
    let nounList = nouns.filter({$0.word(true) != oldSentence.noun.word(true)})
    let noun = pick(list: nounList)
    
    // make a new sentence
    let newSentence = Sentence(adjective1: firstAdj, adjective2: adjective2, noun: noun)
    
    // return the new sentence
    return newSentence
}

// MARK: Create the pool of words
// first are words that will only be in adjective one. There should be a better
// algorithm for sorting these, that will come soon.
// adjectives are words that can be in adjective one or two.
// nouns are words that can only be a noun

private let first = [
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "absolute", meaning: "The most extreme example"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "complete", meaning: "The most extreme example"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "utter", meaning: "The most extreme example")
]

private let adjectives = [
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "artless", meaning: "Without craft or intelligence"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "base-court", meaning: "From the lower English court, common"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "bat-fowling", meaning: "An archaic method of bird hunting, like fishing from a barrel"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "bawdy", meaning: "Humorously indecent"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "bawheeded", meaning: "A person who speaks nonsense"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "beef-witted", meaning: "Brainless, a meat head"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "beetle-headed", meaning: "Witless"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "beslubbering", meaning: "Drooling"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "bloomin’", meaning: "For emphasis"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "boil-brained", meaning: "Filled with thoughts of pestilence and misery"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "bootless", meaning: "Common, or poor"),
    Entry(nsfw: "pussy grabbing", nsfwMeaning: "A conman", sfw: "cat grabbing", meaning: "A man who respects women, and is always concerned for their well being"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "churlish", meaning: "Intentionally rude"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "clapper-clawed", meaning: "Brutish, all hands"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "clarted", meaning: "Mud covered"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "clatty", meaning: "Dirty, slovely, cluttered"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "clay-brained", meaning: "Rock head"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "clouted", meaning: "Senseless, reeling from being beat"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "cockered", meaning: "Spoiled"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "common-kissing", meaning: "Rogue, a rascal, grabs others without permission"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "craven", meaning: "Cowardly"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "crook-pated", meaning: "A thug, a thief who takes by violence"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "currish", meaning: "Like a feral dog, wild and snappish"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "daft", meaning: "Silly, foolish"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "dankish", meaning: "Dark, damp, humid"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "dismal-dreaming", meaning: "A person with foul and depressing dreams or goals"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "dissembling", meaning: "A rambling liar"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "dizzy-eyed", meaning: "Easily distracted"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "doaty", meaning: "A malingerer, one who obsesses over unimportant things"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "doddering", meaning: "Someone who rambles on, complaining of witchhunts and fake news"),
    Entry(nsfw: "dog fucking", nsfwMeaning: nil, sfw: "dog loving", meaning: "Low standards"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "doghearted", meaning: "Inhuman, cruel"),
    Entry(nsfw: "knobdobbing", nsfwMeaning: nil, sfw: "door knobbing", meaning: "Dickish"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "dread-bolted", meaning: "Frightning, terrifying"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "droning", meaning: "One who goes on and on, monotonous, boring and obsessive"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "earth-vexing", meaning: "Causes pain to all around"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "elf-skinned", meaning: "Shrunken, tiny, a mere nothing"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "errant", meaning: "One who wanders from what is right"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "fat-kidneyed", meaning: "Gross, clumsy"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "fawning", meaning: "Obsequious"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "fen-sucked", meaning: "Rising from the marshes"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "fly-bitten", meaning: "Marked by fly bites, wild and unkempt"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "fobbing", meaning: "A con man, a cheat"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "folly-fallen", meaning: "Stooping to foolishness"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "fool-born", meaning: "A second-generation fool"),
    Entry(nsfw: "fucking", nsfwMeaning: "An old germanic word", sfw: "freaking", meaning: "A bad word"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "frothy", meaning: "Of little substance, foolish"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "froward", meaning: "A contrary person, difficult to deal with"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "fuddy", meaning: "Stuffy and old fashioned"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "full-gorged", meaning: "Well fed"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "glaikit", meaning: "Foolish, giddy"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "glakit", meaning: "Unsightly and stupid"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "gleeking", meaning: "Spitting"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "goatish", meaning: "Goatlike in manners"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "gommy", meaning: "Idiotic, mammering"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "gorbellied", meaning: "Corpulent"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "gormless", meaning: "Stupid or dull, lacking in gorm"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "guts-griping", meaning: "Belly aching"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "hackit", meaning: "Ugly"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "half-faced", meaning: "Imperfect, incomplete, defective"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "hasty-witted", meaning: "Shallow"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "hedge-born", meaning: "Of low birth"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "hell-hated", meaning: "Even despised by the Devil"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "howlin’", meaning: "Complaining, waling"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "idle-headed", meaning: "Stupid"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "ill-bred", meaning: "Lacking class"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "ill-nurtured", meaning: "Ill bred, raised common"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "impertinent", meaning: "Not respectful, rude"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "infectious", meaning: "Likely to spread infection"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "jakey", meaning: "A drunken tramp"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "jarring", meaning: "Incongruous, ill fitting"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "knotty-pated", meaning: "Easily distracted"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "lavvy-heided", meaning: "Toilet headed"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "loggerheaded", meaning: "Block headed"),
    Entry(nsfw: nil, nsfwMeaning: "Orange, and pocked", sfw: "loofa-faced", meaning: "Pale and pocked"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "lumpish", meaning: "Roughly or crudely formed"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "malodorous", meaning: "Bad smelling"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "mammering", meaning: "To mumble endlessly without point"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "mangled", meaning: "Disfigured"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "mewling", meaning: "Whimpering"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "milk-livered", meaning: "Gutless, cowardly"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "mingin’", meaning: "Foul smelling"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "motley minded", meaning: "Foolish"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "naffy", meaning: "Self centered fop"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "onion-eyed", meaning: "One so ugly they make your eyes water"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "paunchy", meaning: "Pot bellied"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "pencil-necked", meaning: "Skinny, useless, annoying, weak"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "plume-plucked", meaning: "Humbled"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "pottle-deep", meaning: "Drunken, one who has emptied the dregs of his drink"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "pox-marked", meaning: "Pitted skin, marked with pox"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "pribbling", meaning: "A quibbler who argues just to argue"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "puking", meaning: "Nauseating"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "puny", meaning: "Small and weak"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "qualling", meaning: "Quail like, cowardly"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "rank", meaning: "Low or vile, stinking"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "reeky", meaning: "Stinky"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "reeling-ripe", meaning: "Smelly"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "roguish", meaning: "Loutish, and not in a good way"),
    Entry(nsfw: "cock-juggling", nsfwMeaning: "A promiscous person", sfw: "rooster juggling", meaning: "A fowl manager"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "rude-growing", meaning: "Rough and wild"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "rump-fed", meaning: "Pampered"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "ruttish", meaning: "Salacious, lascivious"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "saucy", meaning: "Lascivious, salacious"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "scabby", meaning: "Covered in scars, ugly"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "shard borne", meaning: "Born in dung"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "sheep-biting", meaning: "A person who preys on the defenseless"),
    Entry(nsfw: nil, nsfwMeaning: "Refering to the size of one's third leg", sfw: "small-handed", meaning: "An observation of manliness"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "spleeny", meaning: "Having a lot of spleen"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "spongy", meaning: "Soft headed"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "spur-galled", meaning: "Ridden hard, put away wet, worn out"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "straw-headed", meaning: "A numpty"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "surly", meaning: "One of the dwarfs"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "swag-bellied", meaning: "Well fed, a golf course owner"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "swollen", meaning: "Distended, fat, puffy"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "tardy-gaited", meaning: "Sluggish"),
    Entry(nsfw: nil, nsfwMeaning: "As reported by Stormy Daniels", sfw: "three-inched", meaning: "An observation of manliness"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "tickle-brained", meaning: "Flighty, unreliable, probably a drunk"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "toad-spotted", meaning: "Spotted like a toad"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "toffee-nosed", meaning: "Having a soft, brown nose"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "tottering", meaning: "Doddering"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "unchin-snouted", meaning: "A face like a hedgehog"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "unmuzzled", meaning: "Unrestrained, obnoxiously capricious"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "vacuous", meaning: "Empty headed"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "vain", meaning: "Self obsessed"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "venomed", meaning: "Poisonous"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "villianous", meaning: "Evil"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "warped", meaning: "Bent, bad"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "wayward", meaning: "Errant"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "weapons-grade", meaning: "The most extreme example of"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "weather-bitten", meaning: "Scarred by a life outside"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "weedy", meaning: "Thin"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "witless", meaning: "Uhh.."),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "yeasty", meaning: "Pale and soft")
]

private let nouns = [
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "apple john", meaning: "Withered"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "arse", meaning: "That thing you sit on"),
    Entry(nsfw: "cocksplat", nsfwMeaning: "The money shot", sfw: "babysplat" , meaning: "Everywhere. Just everywhere"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "baggage", meaning: "A person you would rather not carry"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "bampot", meaning: "An idiot"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "barnacle", meaning: "A clingy person"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "bassa", meaning: "Bastard"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "bawbag", meaning: "An annoying person, a sack"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "bladder", meaning: "A bag of urine"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "boaby", meaning: "Penis"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "boar-pig", meaning: "A pig"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "bugbear", meaning: "A hobgoblin bogeyman"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "bull’s pizzle", meaning: "Pizzle from a bull"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "bum-ailey", meaning: "A bad cop"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "canker blossom", meaning: "A common person"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "clack-dish", meaning: "A beggars bowl"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "clawbaw", meaning: "A person who keeps their hands in thier pockets"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "clotpole", meaning: "A foolish person"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "cockwomble", meaning: "A foolish or obnoxious person"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "codpiece", meaning: "A flap of cloth covering one’s cod"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "coxcomb", meaning: "A dandy, vain and conceited"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "death-token", meaning: "A sign of impending death"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "dewberry", meaning: "A species of berry"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "diddy", meaning: "A tit"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "dobber", meaning: "A tool, a member"),
    Entry(nsfw: "dog-fucker", nsfwMeaning: "A classless heel", sfw: "dog-lover", meaning: "An individual of low standards"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "doiley", meaning: "A foolish old person"),
    Entry(nsfw: "dickweed", nsfwMeaning: nil, sfw: "dorkweed", meaning: "Not a swearword"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "dottard", meaning: "A decript senior as identified by the Leader of North Korea"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "doughnut", meaning: "A person with a hole in their head, witless"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "eejit", meaning: "An idiot"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "fannybaws", meaning: "A twat"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "flap-dragon", meaning: "A raisin floating in a lit glass of rum"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "flax-wench", meaning: "A prostitute"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "flirt gill", meaning: "A wanton person"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "foot-licker", meaning: "A syncophant"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "fud", meaning: "Female genitalia, but more likely a person who does blindingly stupid things"),
    Entry(nsfw: "fucknugget", nsfwMeaning: "The consequences of sex", sfw: "fudge-nugget", meaning: "Mmmm. Fudge"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "fustilarian", meaning: "A scoundrel, but not a space smuggler"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "geek", meaning: "Not athletic, a programmer"),
    Entry(nsfw: "shit-gibbon", nsfwMeaning: "A monkey who flings shit", sfw: "gibbon", meaning: "A monkey"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "giglet", meaning: "A lascivious girl"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "gobshite", meaning: "A natterer, one who doesn’t know how to shut"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "gowk", meaning: "An awkward or foolish person"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "gudgeon", meaning: "A foolish person, gullible"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "haggard", meaning: "A worn out person"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "harpy", meaning: "Virginia Woolf"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "hedge-pig", meaning: "Hedgehog, prickly"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "horn-beast", meaning: "Easily enraged, bestial"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "hugger mugger", meaning: "A pretender"),
    Entry(nsfw: "jizztrumpet", nsfwMeaning: "Someone who plays a trumpet of jizz", sfw: "jazztrumpet", meaning: "Not Miles Davis"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "jobby", meaning: "Feces, junk"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "joithead", meaning: "A hothead"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "lewdster", meaning: "A lecher, a lewd person"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "lickspittle", meaning: "A weak-willed flatterer"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "lout", meaning: "An uncouth, aggressive man"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "maggot-pie", meaning: "A pie of maggots"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "malt-worm", meaning: "A drunkard"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "mammet", meaning: "A scarecrow"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "measle", meaning: "A leper"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "midden", meaning: "A trash heap, a dung hill"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "minnow", meaning: "A small fish in a big pond"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "miscreant", meaning: "A wicked, sinful person"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "moldwarp", meaning: "A mud thrower, a politician"),
    Entry(nsfw: "fucking-moron", nsfwMeaning: "Fucking ignorant of international affairs", sfw: "moron", meaning: "Ignorant of international affairs"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "mumble-news", meaning: "A gossiper, a tattler"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "nimrod", meaning: "A mighty hunter. Not what you expected, is it?"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "numpty", meaning: "A stupid, useless person"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "nut-hook", meaning: "A constable, an officer"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "nyaff", meaning: "A stupid, irritating person"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "pervert", meaning: "Deviant sexual standards"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "pigeon-egg", meaning: "A small useless thing"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "pignut", meaning: "An ugly tuber"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "plamf", meaning: "An underwear sniffer"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "plum", meaning: "A person who says or does stupid things"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "pumpion", meaning: "A person who makes a fool of themselves"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "puttock", meaning: "A greedy, rapacious person"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "ratsbane", meaning: "Rat poisioner"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "roaster", meaning: "A person who makes a fool of themselves"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "rocket", meaning: "An idiot"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "scunner", meaning: "Disgusting, unlikeable"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "scut", meaning: "A foolish or contemptible person"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "skainsmate", meaning: "A shipboard companion"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "strumpet", meaning: "A promiscuous person, a prostitute"),
    Entry(nsfw: "thundercunt", nsfwMeaning:"Queefing genitalia", sfw: "thundercat", meaning: "A cartoon from the 70's"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "tube", meaning: "The cave where you conquer the fear"),
    Entry(nsfw: "shit-tobogganist", nsfwMeaning: "A person who creates chaos just because they fucking love it", sfw: "turd-tobogganist", meaning: "A person who likes to create discord"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "twally-washer", meaning: "Someone who cleans twallies orally"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "twit", meaning: "A annoying, stupid person. Oliver St. John-Mollusc"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "twonk", meaning: "A stupid person"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "varlot", meaning: "A punk"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "vassal", meaning: "A subordinant, servile"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "wagtail", meaning: "A syncophant"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "walloper", meaning: "A male member"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "whalluper", meaning: "A male member"),
    Entry(nsfw: nil, nsfwMeaning: nil, sfw: "whey-face", meaning: "Pale of face, sickly")
]

