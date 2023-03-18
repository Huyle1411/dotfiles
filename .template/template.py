import sys
import os
import io

input = io.BytesIO(os.read(0, os.fstat(0).st_size)).readline

T = int(input())
ans = []
for _ in range(T):

sys.stdout.write("\n".join(map(str, ans)))
