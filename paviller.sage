# Paviller CryptoSystem on SageMath
# Feb. 03, 2016

def getRandom ():
    tmp = 0;
    while (tmp == 0):
        r = ZZ.random_element(2^(512 - 1), 2^512)
        # random number 512 bits from 2^(512 - 1) to 2^215 - 1
        if is_prime(r):
            tmp = 1
    return r

def getKeyList ():
    LKey = []

    # initialize prime number p and q
    p = getRandom()
    q = getRandom()
    while (p == q):
        p = getRandom()
    LKey.append(p) #Lkey[0]
    LKey.append(q) #Lkey[1]

    lambdan = lcm(p - 1, q - 1)
    LKey.append(lambdan) #Lkey[2]

    n = p * q
    LKey.append(n) #Lkey[3]

    if (gcd(n, lambdan) != 1):
        return false

    g = n + 1
    LKey.append(g) #Lkey[4]

    # how it works for returning listKey1 & listKey2 at the same time?
    return LKey


def getPubKey (LKey):
    KPub = []
    KPub.extend(LKey[3:5])
    print("Public Keys: n and g")
    return KPub

def getPriKey (LKey):
    KPri = []
    KPri.extend(LKey[0:3])
    print("Private Keys: p, q and lamdba(n)")
    return KPri

def Encoding (m, KPub):
    n = KPub[0]
    Zn = Integers(n)
    Znn = Integers(n^2)
    g = Znn(KPub[1])
    r = Znn(abs(ZZ.random_element()))
    c = Znn(g^m * r^n)
    return c

def L(u, KPub):
    n = KPub[0]
    Zn = Integers(n)
    Znn = Integers(n^2)
    return Zn((u - 1).lift() / n)

def Decoding (c, KPub, KPri):
    n = KPub[0]
    Zn = Integers(n)
    Znn = Integers(n^2)
    g = Znn(KPub[1])
    lambdan = Znn(KPri[2])

    Pup = L(pow(c, lambdan, n^2), KPub)
    Pdown = L(pow(g, lambdan, n^2), KPub)
    m = Zn(Pup / Pdown)
    return m

# fast test with:
# m = ? # a number as clear message
# getKeyList(); getPubKey (LKey); getPriKey (LKey); c = Encoding (m, KPub); Decoding (c, KPub, KPri)
