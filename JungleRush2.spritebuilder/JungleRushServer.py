from twisted.internet.protocol import Factory, Protocol
from twisted.internet import reactor
from struct import *
 
MESSAGE_PLAYER_CONNECTED = 0
MESSAGE_NOT_IN_MATCH = 1
MESSAGE_START_MATCH = 2
MESSAGE_MATCH_STARTED = 3
MESSAGE_MOVED_SELF = 4
MESSAGE_PLAYER_MOVED = 5
MESSAGE_GAME_OVER = 6
MESSAGE_RESTART_MATCH = 7
MESSAGE_NOTIFY_READY = 8
 
PLAYER_WIN_X = 445
 
MATCH_STATE_ACTIVE = 0
MATCH_STATE_GAME_OVER = 1

class MessageReader:
 
    def __init__(self, data):
        self.data = data
        self.offset = 0
 
    def readByte(self):
        retval = unpack('!B', self.data[self.offset:self.offset+1])[0]
        self.offset = self.offset + 1
        return retval
 
    def readInt(self):
        retval = unpack('!I', self.data[self.offset:self.offset+4])[0]
        self.offset = self.offset + 4
        return retval
 
    def readString(self):
        strLength = self.readInt()
        unpackStr = '!%ds' % (strLength)
        retval = unpack(unpackStr, self.data[self.offset:self.offset+strLength])[0]
        self.offset = self.offset + strLength
        return retval

class MessageWriter:
 
    def __init__(self):
        self.data = ""
 
    def writeByte(self, value):        
        self.data = self.data + pack('!B', value)
 
    def writeInt(self, value):
        self.data = self.data + pack('!I', value)
 
    def writeString(self, value):
        self.writeInt(len(value))
        packStr = '!%ds' % (len(value))
        self.data = self.data + pack(packStr, value)

class RaceMatch:
 
    def __init__(self, players):
        self.players = players
        self.state = MATCH_STATE_ACTIVE
 
    def __repr__(self):
        return "%d %s" % (self.state, str(self.players))
 
    def write(self, message):
        message.writeByte(self.state)
        message.writeByte(len(self.players))
        for matchPlayer in self.players:            
            matchPlayer.write(message)

    def movedSelf(self, posX, player):
        if (self.state == MATCH_STATE_GAME_OVER):
            return
        player.posX = posX
        if (player.posX >= PLAYER_WIN_X):
            self.state = MATCH_STATE_GAME_OVER
            for matchPlayer in self.players:
                if (matchPlayer.protocol):
                    matchPlayer.protocol.sendGameOver(player.match.players.index(player))
        for i in range(0, len(self.players)):
            matchPlayer = self.players[i]
            if matchPlayer != player:
                if (matchPlayer.protocol):
                    matchPlayer.protocol.sendPlayerMoved(i, posX)

    def restartMatch(self, player):
        if (self.state == MATCH_STATE_ACTIVE):
            return
        self.state = MATCH_STATE_ACTIVE
        for matchPlayer in self.players:
            matchPlayer.posX = 25
        for matchPlayer in self.players:
            if (matchPlayer.protocol):
                matchPlayer.protocol.sendMatchStarted(self)

class RacePlayer:
 
    def __init__(self, protocol, playerId, alias):
        self.protocol = protocol
        self.playerId = playerId
        self.alias = alias
        self.match = None
        self.posX = 25
 
    def __repr__(self):
        return "%s:%d" % (self.alias, self.posX)
 
    def write(self, message):
        message.writeString(self.playerId)
        message.writeString(self.alias)
        message.writeInt(self.posX)

class RaceFactory(Factory):
    def __init__(self):
        self.protocol = RaceProtocol
        self.players = []
 
    def connectionLost(self, protocol):
        for existingPlayer in self.players:
            if existingPlayer.protocol == protocol:
                existingPlayer.protocol = None        
 
    def playerConnected(self, protocol, playerId, alias, continueMatch):
        for existingPlayer in self.players:
            if existingPlayer.playerId == playerId:
                existingPlayer.protocol = protocol
                protocol.player = existingPlayer
                if (existingPlayer.match):
                    print "TODO: Already in match case"
                    if (continueMatch):
                        existingPlayer.protocol.sendMatchStarted(existingPlayer.match) 
                    else:
                        print "Quitting match!"
                        existingPlayer.match.quit()
                else:
                    existingPlayer.protocol.sendNotInMatch()
                return
        newPlayer = RacePlayer(protocol, playerId, alias)
        protocol.player = newPlayer
        self.players.append(newPlayer)
        newPlayer.protocol.sendNotInMatch()

    def startMatch(self, playerIds):
        matchPlayers = []
        for existingPlayer in self.players:
            if existingPlayer.playerId in playerIds:
                if existingPlayer.match != None:
                    return
                matchPlayers.append(existingPlayer)
        match = CatRaceMatch(matchPlayers)
        for matchPlayer in matchPlayers:
            matchPlayer.match = match
            matchPlayer.protocol.sendMatchStarted(match)


class RaceProtocol(Protocol):
 
    def __init__(self):
        self.inBuffer = ""
        self.player = None
 
    def log(self, message):
        if (self.player):
            print "%s: %s" % (self.player.alias, message)
        else:
            print "%s: %s" % (self, message) 
 
    def connectionMade(self):
        self.log("Connection made")
 
    def connectionLost(self, reason):
        self.log("Connection lost: %s" % str(reason))
        self.factory.connectionLost(self)
 
    def sendMessage(self, message):
        msgLen = pack('!I', len(message.data))
        self.transport.write(msgLen)
        self.transport.write(message.data)
 
    def sendNotInMatch(self):
        message = MessageWriter()
        message.writeByte(MESSAGE_NOT_IN_MATCH)
        self.log("Sent MESSAGE_NOT_IN_MATCH")
        self.sendMessage(message)

    def playerConnected(self, message):
        playerId = message.readString()
        alias = message.readString()
        continueMatch = message.readByte()
        self.log("Recv MESSAGE_PLAYER_CONNECTED %s %s %d" % (playerId, alias, continueMatch))
        self.factory.playerConnected(self, playerId, alias, continueMatch)
 
    def processMessage(self, message):
        messageId = message.readByte()        
 
        if messageId == MESSAGE_PLAYER_CONNECTED:            
            return self.playerConnected(message)
        if messageId == MESSAGE_START_MATCH:
            return self.startMatch(message)
        # Match specific messages
        if (self.player == None):
            self.log("Bailing - no player set")
            return
        if (self.player.match == None):
            self.log("Bailing - no match set")
            return
        if messageId == MESSAGE_MOVED_SELF:            
            return self.movedSelf(message)
        if messageId == MESSAGE_RESTART_MATCH:
            return self.restartMatch(message)
        if messageId == MESSAGE_NOTIFY_READY:
            return self.notifyReady(message)
 
        self.log("Unexpected message: %d" % (messageId))
 
    def dataReceived(self, data):
 
        self.inBuffer = self.inBuffer + data
 
        while(True):
            if (len(self.inBuffer) < 4):
                return;
 
            msgLen = unpack('!I', self.inBuffer[:4])[0]
            if (len(self.inBuffer) < msgLen):
                return;
 
            messageString = self.inBuffer[4:msgLen+4]
            self.inBuffer = self.inBuffer[msgLen+4:]
 
            message = MessageReader(messageString)
            self.processMessage(message)

    def sendMatchStarted(self, match):
        message = MessageWriter()
        message.writeByte(MESSAGE_MATCH_STARTED)
        match.write(message)
        self.log("Sent MATCH_STARTED %s" % (str(match)))
        self.sendMessage(message)
 
    def startMatch(self, message):
        numPlayers = message.readByte()
        playerIds = []
        for i in range(0, numPlayers):
            playerId = message.readString()
            playerIds.append(playerId)
        self.log("Recv MESSAGE_START_MATCH %s" % (str(playerIds)))
        self.factory.startMatch(playerIds)

    def sendPlayerMoved(self, playerIndex, posX):
        message = MessageWriter()
        message.writeByte(MESSAGE_PLAYER_MOVED)
        message.writeByte(playerIndex)
        message.writeInt(posX)
        self.log("Sent PLAYER_MOVED %d %d" % (playerIndex, posX))
        self.sendMessage(message)
 
    def sendGameOver(self, winnerIndex):
        message = MessageWriter()
        message.writeByte(MESSAGE_GAME_OVER)
        message.writeByte(winnerIndex)
        self.log("Sent MESSAGE_GAME_OVER %d" % (winnerIndex))
        self.sendMessage(message)
 
    def movedSelf(self, message):
        posX = message.readInt()
        self.log("Recv MESSAGE_MOVED_SELF %d" % (posX))
        self.player.match.movedSelf(posX, self.player)

    def restartMatch(self, message):
        self.log("Recv MESSAGE_RESTART_MATCH")
        self.player.match.restartMatch(self.player)

    def sendNotifyReady(self, playerId):
        message = MessageWriter()
        message.writeByte(MESSAGE_NOTIFY_READY)
        message.writeString(playerId)
        self.log("Sent PLAYER_NOTIFY_READY %s" % (playerId))
        self.sendMessage(message)
 
    def notifyReady(self, message):
        inviter = message.readString()
        self.log("Recv MESSAGE_NOTIFY_READY %s" % (inviter))
        self.factory.notifyReady(self.player, inviter)


factory = RaceFactory()
reactor.listenTCP(5566, factory)
print "Race server started"
reactor.run()

