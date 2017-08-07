import json
import numpy as np

def readJsonFrom(fileName):
	f = open(fileName)
	records = json.load(f)
	return records


def writJsonToFile(object, fileName):
	with open(fileName, 'w') as outfile:
	    json.dump(object, outfile)


def iterPrintMap(map, keyFilter=""):
	if keyFilter == "":
		for k, v in map.iteritems():
			print k, v
		return

	for k, v in map.iteritems():
		if keyFilter in k:
			print k, v


def result_of_episode(episode):
	result = episode[-1][3]
	if result in ["dealerWin", "dealerBlackJack", "playerBusted"]:
		return -1
	elif result in ["playerWin", "dealerBusted"]:
		return 1
	elif result == "playerBlackJack":
		return 1
	elif result == "push":
		return 0
	else:
		print result, "not handled"
		exit()


def getValueFuntionFromRecord(records, V={}):
	for episode in records:
		result = result_of_episode(episode)
		for item in episode:
			dealerValue = item[0]
			playerValue = item[1]
			action = item[2]

			s = str(dealerValue) + "-" + str(playerValue)
			a = action
			r = result
			
			if s not in V:
				V[s] = {}
			if a not in V[s]:
				V[s][a] = {}
			if r not in V[s][a]:
				V[s][a][r] = 1
			else:	
				V[s][a][r] = V[s][a][r] + 1	
	return V


def getInitialHandsStatesFromRecords(records):
	states = {}
	for episode in records:
		initial = episode[0]
		dealerValue = initial[0]
		playerValue = initial[1]
		s = str(dealerValue) + "-" + str(playerValue)
		states[s] = True
	return states


def getProbilityFromValueFunction(V):
	P = {}
	for s, amap in V.iteritems():
		for a, rmap in amap.iteritems():
			total = sum(rmap.values())
			for r, time in rmap.iteritems():
				if s not in P:
					P[s] = {}
				if a not in P[s]:
					P[s][a] = {}
				P[s][a][r] = float(time)/total
	return P


def getPolicyFromProbility(P):
	OP = {}
	for s, amap in P.iteritems():
		vmax = -1
		amax = 0
		for a, rmap in amap.iteritems():
			v = 0
			if 1 in rmap:
				v = rmap[1]
			if v > vmax:
				vmax = v
				amax = a
		OP[s] = (amax, vmax)
	return OP


def hasAceInPlayerHands(s):
	arr = s.split("-")
	playerHands = arr[1]
	if "," in playerHands:
		return True
	else:
		return False




ftype = '10m'
records = readJsonFrom('bj-' + ftype + '.json')
V = getValueFuntionFromRecord(records)
P = getProbilityFromValueFunction(V)
OP = getPolicyFromProbility(P)
# writJsonToFile(P, 'P-' + ftype + '.json')
initialStates = getInitialHandsStatesFromRecords(records)

print "record num: ", len(records)
print "initial state num", len(initialStates)
print "state num: ", len(V)

initialPolicy = {}
for s in initialStates.keys():
	initialPolicy[s] = OP[s]

for s, (a, p) in initialPolicy.iteritems():
	if hasAceInPlayerHands(s):
		continue
	# print s, p

for k in initialStates.keys():
	print k


x = range(4,21) # 4 5 ... 20
y = range(1,10) # (1,11) 2 3 ... 10

def valueAt(coor):
	x = coor[0] # player
	y = coor[1] # dealer
	s = str([y]) + "-" + str([x])
	if y == 1:
		s = str([1,11]) + "-" + str([x])

	global initialPolicy
	return initialPolicy[s][1]

xgrid, ygrid = np.meshgrid(x, y)
zgrid = np.dstack([xgrid, ygrid])
z = np.apply_along_axis(valueAt, 2, zgrid)

from SurfacePlot import *
# matplot_surface(xgrid, ygrid, z, "{} (No Usable Ace)".format("test"))
plotly_surface(x, y, z)



x = range(1,10) # A + (A 2 3 ... 10)
y = range(1,10) # (1,11) 2 3 ... 10
def valueAtWithAce(coor):
	x = coor[0] # player
	y = coor[1] # dealer

	player = str([x+1,x+11])
	dealer = str([1,11]) if y == 1 else str([y])
	s = dealer + "-" + player

	global initialPolicy
	if s in initialPolicy:
		return initialPolicy[s][1]
	else:
		player = str([x+11,x+1])
		s = dealer + "-" + player
		return initialPolicy[s][1]

xgrid, ygrid = np.meshgrid(x, y)
zgrid = np.dstack([xgrid, ygrid])
z = np.apply_along_axis(valueAtWithAce, 2, zgrid)
# matplot_surface(xgrid, ygrid, z, "{} (No Usable Ace)".format("test"))
plotly_surface(x, y, z)










