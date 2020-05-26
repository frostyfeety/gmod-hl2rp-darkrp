DarkRP.hookStub{
    name = "canChatSound",
    description = "Whether a chat sound can be played.",
    parameters = {
        {
            name = "ply",
            description = "The player who triggered the chat sound.",
            type = "Player"
        },
        {
            name = "chatPhrase",
            description = "The chat sound phrase that has been detected.",
            type = "string"
        },
        {
            name = "chatText",
            description = "The whole chat text the player sent that contains the chat sound phrase.",
            type = "string"
        }
    },
    returns = {
        {
            name = "canChatSound",
            description = "False if the chat sound should not be played.",
            type = "boolean"
        }
    }
}

DarkRP.hookStub{
    name = "onChatSound",
    description = "When a chat sound is played.",
    parameters = {
        {
            name = "ply",
            description = "The player who triggered the chat sound.",
            type = "Player"
        },
        {
            name = "chatPhrase",
            description = "The chat sound phrase that was detected.",
            type = "string"
        },
        {
            name = "chatText",
            description = "The whole chat text the player sent that contains the chat sound phrase.",
            type = "string"
        }
    },
    returns = {
    }
}

DarkRP.getChatSound = DarkRP.stub{
    name = "getChatSound",
    description = "Get a chat sound (play a noise when someone says something) associated with the given phrase.",
    parameters = {
        {
            name = "text",
            description = "The text that triggers the chat sound.",
            type = "string",
            optional = false
        }
    },
    returns = {
        {
            name = "soundPaths",
            description = "A table of string sound paths associated with the given text.",
            type = "table"
        }
    },
    metatable = DarkRP
}

DarkRP.setChatSound = DarkRP.stub{
    name = "setChatSound",
    description = "Set a chat sound (play a noise when someone says something)",
    parameters = {
        {
            name = "text",
            description = "The text that should trigger the sound.",
            type = "string",
            optional = false
        },
        {
            name = "sounds",
            description = "A table of string sound paths.",
            type = "table",
            optional = false
        }
    },
    returns = {
    },
    metatable = DarkRP
}