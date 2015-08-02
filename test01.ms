pl11 = #(-4416.68, 249.134, -630.006, -56189.9)
pl12 = #(-2491.46, -957.678, 1499.11, 51095.5)
pl13 = #(-2707.02, 3619.27, 1337.02, 90711.9)
pl1b = #(-0.000488281, 1066.48, 3526.31, 187345.0)
plArr = #(pl11, pl12, pl13, pl1b)
fn sortFunc inArr =
(
	sortArr = #()
	for i = 1 to (inArr.count - 1) do
	(
		if i != (inArr.count - 1) then
		(
			t = #(inArr.count, i, i+1)
			append sortArr t
		)
		else
		(
			t = #(inArr.count, i, 1)
			append sortArr t
		)
	)
	sortArr
)
sortedArr = sortFunc plArr
fn plIntersect inArr sortArr =
(
	for i = 1 to sortArr.count do 
	(
		fnIn = #()
		for n in sortArr[i] do
		(
			h = inArr[n]
			append fnIn h
-- 			format "%: %\n" n h
		)
-- 		print (fnIn as string)
		a1 = fnIn[1][1]; b1 = fnIn[1][2]; c1 = fnIn[1][3]; s1 = -fnIn[1][4];
		a2 = fnIn[2][1]; b2 = fnIn[2][2]; c2 = fnIn[2][3]; s2 = -fnIn[2][4]; 
		a3 = fnIn[3][1]; b3 = fnIn[3][2]; c3 = fnIn[3][3]; s3 = -fnIn[3][4]; 
		format "% % % %\n" a1 b1 c1 s1
		format "% % % %\n" a2 b2 c2 s2
		format "% % % %\n" a3 b3 c3 s3
		D = a1*b2*c3 + a3*b1*c2+a2*b3*c1-a3*b2*c1-a1*b3*c2-a2*b1*c3
		print (D == 0.0)
		if D != 0.0 then
		(
			D1 = s1*b2*c3 + s3*b1*c2+s2*b3*c1-s3*b2*c1-s1*b3*c2-s2*b1*c3
			D2 = a1*s2*c3 + a3*s1*c2+a2*s3*c1-a3*s2*c1-a1*s3*c2-a2*s1*c3
			D3 = a1*b2*s3 + a3*b1*s2+a2*b3*s1-a3*b2*s1-a1*b3*s2-a2*b1*s3
			fx = D1/D; fy = D2/D; fz = D3/D;
			fin = [fx, fy, fz]
			print fin
			te1 = a1*fx+b1*fy+c1*fz
			te2 = a2*fx+b2*fy+c2*fz
			te3 = a3*fx+b3*fy+c3*fz
			format " % \n % \n % \n" te1 te2 te3
		)
	)
)

plIntersect plArr sortedArr