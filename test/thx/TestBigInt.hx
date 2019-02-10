package thx;

import utest.Assert;
import thx.BigInt;
import thx.Int64s;
using haxe.Int64;

class TestBigInt {
  public function new() {}

//   public function testIssue82() {
//     var s : BigInt = 101;
//     var b : BigInt = new thx.bigint.Big(thx.bigint.Bigs.smallToArray(BigInt.fromString("100")), false);
//     var r = s - b;
//     Assert.isTrue(1 == s - b, 'expected $s - $b to be equal 1 but it is $r');

//     var s : BigInt = 101;
//     var b : BigInt = 10;
//     b = b.pow(2);
//     var r = s - b;
//     Assert.isTrue(1 == s - b, 'expected $s - $b to be equal 1 but it is $r');
//   }

//   public function testFromInt64() {
//     var values = [Int64s.minValue, Int64.ofInt(-1), Int64.ofInt(0), Int64.ofInt(1), Int64s.maxValue];
//     for(value in values) {
//       var r = BigInt.fromInt64(value),
//           i = r.toInt64();
//       Assert.isTrue(i == value, 'Int64 parsed as ${r} and converted to ${i} but expected $value');
//     }
//   }

//   public function testLcmAndGcd() {
//     Assert.isTrue((21 : BigInt).lcm(6) == 42);
//     Assert.isTrue((42 : BigInt).gcd(56) == 14);
//     Assert.isTrue((0 : BigInt).gcd(56) == 56);
//     Assert.isTrue((42 : BigInt).gcd(0) == 42);
//     Assert.isTrue((17 : BigInt).gcd(103) == 1);
//   }

//   public function testIncrements() {
//     Assert.isTrue(BigInt.zero.isZero());
//     var a = BigInt.zero,
//         b = ++a,
//         c = a++,
//         d = --a,
//         e = a--;
//     Assert.isTrue(BigInt.zero.isZero());
//     Assert.isTrue(b == 1);
//     Assert.isTrue(c == 1);
//     Assert.isTrue(d == 1);
//     Assert.isTrue(e == 1);
//     Assert.isTrue(a == 0);
//   }

//   public function testCanHandleLargeNumbers() {
//     var tenFactorial : BigInt = "3628800",
//         hundredFactorial : BigInt = "93326215443944152681699238856266700490715968264381621468592963895217599993229915608941463976156518286253697920827223758251185210916864000000000000000000000000",
//         threeToTenThousand : BigInt = "16313501853426258743032567291811547168121324535825379939348203261918257308143190787480155630847848309673252045223235795433405582999177203852381479145368112501453192355166224391025423628843556686559659645012014177448275529990373274425446425751235537341867387607813619937225616872862016504805593174059909520461668500663118926911571773452255850626968526251879139867085080472539640933730243410152186914328917354576854457274195562218013337745628502470673059426999114202540773175988199842487276183685299388927825296786440252999444785694183675323521704432195785806270123388382931770198990841300861506996108944782065015163410344894945809337689156807686673462563038164792190665340124344133980763205594364754963451564072340502606377790585114123814919001637177034457385019939060232925194471114235892978565322415628344142184842892083466227875760501276009801530703037525839157893875741192497705300469691062454369926795975456340236777734354667139072601574969834312769653557184396147587071260443947944862235744459711204473062937764153770030210332183635531818173456618022745975055313212598514429587545547296534609597194836036546870491771927625214352957503454948403635822345728774885175809500158451837389413798095329711993092101417428406774326126450005467888736546254948658602484494535938888656542746977424368385335496083164921318601934977025095780370104307980276356857350349205866078371806065542393536101673402017980951598946980664330391505845803674248348878071010412918667335823849899623486215050304052577789848512410263834811719236949311423411823585316405085306164936671137456985394285677324771775046050970865520893596151687017153855755197348199659070192954771308347627111052471134476325986362838585959552209645382089055182871854866744633737533217524880118401787595094060855717010144087136495532418544241489437080074716158404895914136451802032446707961058757633345691696743293869623745410870051851590672859347061212573446572045088465460616826082579731686004585218284333452396157730036306379421822435818001505905203918209206969662326706952623512427380240468784114535101496733983401240219840048956733689309620321613793757156727562461651933397540266795963865921590913322060572673349849253303397874242381960775337182730037783698708748781738419747698880321601186310506332869704931303076839444790968339306301273371014087248060946851793697973114432706759288546077622831002526800554849696867710280945946603669593797354642136622231192695027321229511912952940320879763123151760555959496961163141455688278842949587288399100273691880018774147568892650186152065335219113072582417699616901995530249937735219099786758954892534365835235843156112799728164123461219817343904782402517111603206575330527850752564642995318064985900815557979945885931124351303252811255254295797082281946658798705979077492469849644183166585950844953164726896146168297808178398470451561320526180542310840744843107469368959707726836608471817060598771730170755446473440774031371227437651048421606224757527085958515947273151027400662948161111284777828103531499488913672800783167888051177155427285103861736658069404797695900758820465238673970882660162285107599221418743657006872537842677883708807515850397691812433880561772652364847297019508025848964833883225165668986935081274596293983121864046277268590401580209059988500511262470167150495261908136688693861324081559046336288963037090312033522400722360882494928182809075406914319957044927504420797278117837677431446979085756432990753582588102440240611039084516401089948868433353748444104639734074519165067632941419347985624435567342072815910754484123812917487312938280670403228188813003978384081332242484646571417574404852962675165616101527367425654869508712001788393846171780457455963045764943565964887518396481296159902471996735508854292964536796779404377230965723361625182030798297734785854606060323419091646711138678490928840107449923456834763763114226000770316931243666699425694828181155048843161380832067845480569758457751090640996007242018255400627276908188082601795520167054701327802366989747082835481105543878446889896230696091881643547476154998574015907396059478684978574180486798918438643164618541351689258379042326487669479733384712996754251703808037828636599654447727795924596382283226723503386540591321268603222892807562509801015765174359627788357881606366119032951829868274617539946921221330284257027058653162292482686679275266764009881985590648534544939224296689791195355783205968492422636277656735338488299104238060289209390654467316291591219712866052661347026855261289381236881063068219249064767086495184176816629077103667131505064964190910450196502178972477361881300608688593782509793781457170396897496908861893034634895715117114601514654381347139092345833472226493656930996045016355808162984965203661519182202145414866559662218796964329217241498105206552200001";
//     function factorial(n : BigInt) : BigInt {
//       if (n == 0 || n == 1) {
//         return 1;
//       }
//       return factorial(n.prev()) * n;
//     }

//     Assert.isTrue(factorial(10) == tenFactorial);
//     Assert.isTrue(factorial(100) == hundredFactorial);

// #if !python // not sure what is wrong with python
//     var pow = (3 : BigInt).pow((10000));

//     Assert.isTrue(
//       pow == threeToTenThousand,
//       'expected ${(3 : BigInt)}.pow(10000) == $threeToTenThousand but got $pow'
//     );
// #end
//   }

//   public function testIsImmutable() {
//     var n : BigInt = 14930352;
//     n.add(9227465);
//     Assert.isTrue(n == 14930352);
//     n.subtract(123456);
//     Assert.isTrue(n == 14930352);
//   }

//   public function testInts() {
//     var tests = [
//           1, 2, 4, 8, 16, 32, 64, 128, 256,
//           512, 1024, 2048, 4096, 10000, 100000,
//           1000000, 10000000
//         ];
//     for(test in tests) {
//       var out : BigInt = test;
//       Assert.equals(test, out.toInt(), 'expected $test but got ${out.toInt()}');

//       var out : BigInt = -test;
//       Assert.equals(-test, out.toInt(), 'expected ${-test} but got ${out.toInt()}');
//     }
//   }

//   public function testFloats() {
//     var tests = [0.0, 1.0, 5.0, 1.2e20, 1.2e40, 1.234e63, 5.432e80, 0.00001, 1.2345e-50];

//     for(test in tests) {
//       var out : BigInt = test;
//       Assert.floatEquals(Floats.roundTo(test, 0), out.toFloat(), 'expected ${Floats.roundTo(test, 0)} but got ${out.toFloat()}');

//       var out : BigInt = -test;
//       Assert.floatEquals(Floats.roundTo(-test, 0), out.toFloat(), 'expected ${Floats.roundTo(-test, 0)} but got ${out.toFloat()}');
//     }
//   }

//   public function testStrings() {
//     var tests = ["0", "3", "20",
//                  "12345678901234567890",
//                  "999999999999999999"
//                 ];

//     for(test in tests) {
//       var out : BigInt = test;
//       Assert.equals(test, out.toString(), 'expected $test but got ${out.toString()}');

//       if(test == "0")
//         continue;

//       var out : BigInt = '-$test';
//       Assert.equals('-$test', out.toString(), 'expected -$test but got ${out.toString()}');
//     }
//   }

//   public function testEquals() {
//     Assert.isTrue((0 : BigInt) == (0 : BigInt));
//     Assert.isTrue((1 : BigInt) == (1 : BigInt));
//     Assert.isTrue(("12345678901234567890" : BigInt) == ("12345678901234567890" : BigInt));
//     Assert.isTrue((-1 : BigInt) == (-1 : BigInt));
//     Assert.isTrue(("-12345678901234567890" : BigInt) == ("-12345678901234567890" : BigInt));

//     Assert.isFalse((0 : BigInt) != (0 : BigInt));
//     Assert.isFalse((1 : BigInt) != (1 : BigInt));
//     Assert.isFalse(("12345678901234567890" : BigInt) != ("12345678901234567890" : BigInt));
//     Assert.isFalse((-1 : BigInt) != (-1 : BigInt));
//     Assert.isFalse(("-12345678901234567890" : BigInt) != ("-12345678901234567890" : BigInt));
//     Assert.isTrue(("-12345678901234567890" : BigInt) != ("12345678901234567890" : BigInt));

//     Assert.isTrue((0 : BigInt) != (1 : BigInt));
//     Assert.isTrue((1 : BigInt) != (2 : BigInt));
//     Assert.isTrue(("12345678901234567890" : BigInt) != ("12345678901234567891" : BigInt));
//     Assert.isTrue((-1 : BigInt) != (-2 : BigInt));
//     Assert.isTrue(("-12345678901234567890" : BigInt) != ("-12345678901234567891" : BigInt));

//     Assert.isFalse((0 : BigInt) == (1 : BigInt));
//     Assert.isFalse((1 : BigInt) == (2 : BigInt));
//     Assert.isFalse(("12345678901234567890" : BigInt) == ("12345678901234567891" : BigInt));
//     Assert.isFalse((-1 : BigInt) == (-2 : BigInt));
//     Assert.isTrue((2 : BigInt) != (-2 : BigInt));
//     Assert.isFalse((2 : BigInt) == (-2 : BigInt));
//     Assert.isFalse(("-12345678901234567890" : BigInt) == ("-12345678901234567891" : BigInt));

//     Assert.isTrue((0 : BigInt) == ("-0" : BigInt));
//   }

//   public function testIgnoreLeadingZeros() {
//     Assert.isTrue(("0000000000" : BigInt) == "0");
//     Assert.isTrue(("000000000000023" : BigInt) == 23);
//     Assert.isTrue(("-0000000000000000000000123" : BigInt) == -123, 'expected ${("-0000000000000000000000123" : BigInt)} == ${(-123 : BigInt)} to be true');
//   }

//   public function testNumbersShouldBeTheSameWhenConstructedDifferently() {
//     Assert.isTrue(("12e5" : BigInt) == 12e5, 'expected ${("12e5" : BigInt)} == ${(12e5 : BigInt)} to be true');
//     Assert.isTrue((12e5 : BigInt) == "1200000", 'expected ${(12e5 : BigInt)} == ${("1200000" : BigInt)} to be true');
//     Assert.isTrue(("1" : BigInt) == 1, 'expected ${("1" : BigInt)} == ${(1 : BigInt)} to be true');
//     Assert.isTrue((12345 : BigInt) == "12345", 'expected ${(12345 : BigInt)} == ${("12345" : BigInt)} to be true');
//     Assert.isTrue(("9876543210" : BigInt) == 9876543210.0, 'expected ${("9876543210" : BigInt)} == ${(9876543210.0 : BigInt)} to be true');
//   }

//   public function testFibonacci() {
//     var fibs : Array<BigInt> = ["1", "1", "2", "3", "5", "8", "13", "21", "34", "55", "89", "144", "233", "377", "610", "987", "1597", "2584", "4181", "6765", "10946", "17711", "28657", "46368", "75025", "121393", "196418", "317811", "514229", "832040", "1346269", "2178309", "3524578", "5702887", "9227465", "14930352", "24157817", "39088169", "63245986", "102334155", "165580141", "267914296", "433494437", "701408733", "1134903170", "1836311903", "2971215073", "4807526976", "7778742049", "12586269025"];
//     var number : BigInt = 1;
//     var last : BigInt = 1;

//     for (i in 2...50) {
//       number = number + last;
//       last = number - last;
//       Assert.isTrue(number == fibs[i]);
//     }
//   }

//   public function testCarriesOverCorrectly() {
//     Assert.isTrue(("9007199254740991" : BigInt) + 1 == "9007199254740992");
//     Assert.isTrue(("999999999999999999999000000000000000000000" : BigInt) +
//       ("1000000000000000000000" : BigInt) == ("1e42" : BigInt),
//       'expected ${("999999999999999999999000000000000000000000" : BigInt)} + ${("1000000000000000000000" : BigInt)} == ${("1e42" : BigInt)} but is ${("999999999999999999999000000000000000000000" : BigInt) + ("1000000000000000000000" : BigInt)}');
//     Assert.isTrue(("1e20" : BigInt) + "9007199254740972" == "100009007199254740972");
//     Assert.isTrue(("-9007199254740983" : BigInt) + "-9999999999999998" == "-19007199254740981");
//     Assert.isTrue(("100000000000000000000000000000000000" : BigInt) - "999999999999999999" == "99999999999999999000000000000000001");

//     Assert.isTrue(("50000005000000" : BigInt) * "10000001" == "500000100000005000000");
//   }

//   public function testMisc() {
//     Assert.isTrue(("10" : BigInt) + 10 == "20");
//     Assert.isTrue(("-10000000000000000" : BigInt) + "0" == "-10000000000000000");
//     Assert.isTrue(("0" : BigInt) + "10000000000000000" == "10000000000000000");
//     Assert.isTrue((9999999 : BigInt) + 1 == 10000000, 'expected ${(9999999 : BigInt)} + ${(1 : BigInt)} == ${(10000000 : BigInt)} but got ${(9999999 : BigInt) + (1 : BigInt)}');
//     Assert.isTrue((10000000 : BigInt) - 1 == 9999999);
//     Assert.isTrue(("-1000000000000000000000000000000000001" : BigInt) + "1000000000000000000000000000000000000" == -1);
//     Assert.isTrue(("100000000000000000002222222222222222222" : BigInt) - "100000000000000000001111111111111111111" == "1111111111111111111");
//     Assert.isTrue(("1" : BigInt) + "0" == "1");
//     Assert.isTrue(("10" : BigInt) + "10000000000000000" == "10000000000000010");
//     Assert.isTrue(("10000000000000000" : BigInt) + "10" == "10000000000000010");
//     Assert.isTrue(("10000000000000000" : BigInt) + "10000000000000000" == "20000000000000000");
//   }

//   public function testMultiplyHandlesSignsCorectly() {
//     Assert.isTrue((100 : BigInt) * 100 == 10000);
//     Assert.isTrue((100 : BigInt) * -100 == -10000);
//     Assert.isTrue((-100 : BigInt) * 100 == -10000);
//     Assert.isTrue((-100 : BigInt) * -100 == 10000);

//     Assert.isTrue(
//       (13579 : BigInt) * "163500573666152634716420931676158" == "2220174289812686626814279831230549482",
//       'expected ${(13579 : BigInt)} * ${("163500573666152634716420931676158" : BigInt)} == ${("2220174289812686626814279831230549482" : BigInt)} but got ${(13579 : BigInt) * ("163500573666152634716420931676158" : BigInt)}'
//     );

//     Assert.isTrue((13579 : BigInt) * "-163500573666152634716420931676158" == "-2220174289812686626814279831230549482");
//     Assert.isTrue((-13579 : BigInt) * "163500573666152634716420931676158" == "-2220174289812686626814279831230549482");
//     Assert.isTrue((-13579 : BigInt) * "-163500573666152634716420931676158" == "2220174289812686626814279831230549482");
//     Assert.isTrue(
//       ("163500573666152634716420931676158" : BigInt) * 13579 == "2220174289812686626814279831230549482",
//       'expected ${("163500573666152634716420931676158" : BigInt)} * 13579 == ${("2220174289812686626814279831230549482" : BigInt)} but got ${("163500573666152634716420931676158" : BigInt) * 13579}'
//     );
//     Assert.isTrue(("163500573666152634716420931676158" : BigInt) * -13579 == "-2220174289812686626814279831230549482");
//     Assert.isTrue(("-163500573666152634716420931676158" : BigInt) * 13579 == "-2220174289812686626814279831230549482");
//     Assert.isTrue(("-163500573666152634716420931676158" : BigInt) * -13579 == "2220174289812686626814279831230549482");
//     Assert.isTrue(("163500573666152634716420931676158" : BigInt) * -1 == "-163500573666152634716420931676158");
//     Assert.isTrue(("1234567890987654321" : BigInt) * "132435465768798" == "163500573666152634716420931676158");
//     Assert.isTrue(("1234567890987654321" : BigInt) * "-132435465768798" == "-163500573666152634716420931676158", 'expected ${("1234567890987654321" : BigInt)} * ${("-132435465768798" : BigInt)} == ${("-163500573666152634716420931676158" : BigInt)} but got ${("1234567890987654321" : BigInt) * "-132435465768798"}');
//     Assert.isTrue(("-1234567890987654321" : BigInt) * "132435465768798" == "-163500573666152634716420931676158", 'expected ${("-1234567890987654321" : BigInt)} * ${("132435465768798" : BigInt)} == ${("-163500573666152634716420931676158" : BigInt)} but got ${("-1234567890987654321" : BigInt) * "132435465768798"}');
//     Assert.isTrue(("-1234567890987654321" : BigInt) * "-132435465768798" == "163500573666152634716420931676158", 'expected ${("-1234567890987654321" : BigInt)} * ${("-132435465768798" : BigInt)} == ${("163500573666152634716420931676158" : BigInt)} but got ${("-1234567890987654321" : BigInt) * "-132435465768798"}');
//   }

//   public function testDivisionBy1IsTheIdentity() {
//     Assert.isTrue((1 : BigInt) / 1 == 1);
//     Assert.isTrue((-1 : BigInt) / 1 == -1);
//     Assert.isTrue((1 : BigInt) / -1 == -1);
//     Assert.isTrue((153 : BigInt) / 1 == 153);
//     Assert.isTrue((-153 : BigInt) / 1 == -153);
//     Assert.isTrue(("9844190321790980841789" : BigInt) / 1 == "9844190321790980841789");
//     Assert.isTrue(("-9844190321790980841789" : BigInt) / 1 == "-9844190321790980841789");
//   }

//   public function testDivisionBySelfIs1() {
//     Assert.isTrue((5 : BigInt) / 5 == 1);
//     Assert.isTrue((-5 : BigInt) / -5 == 1);
//     Assert.isTrue(("20194965098495006574" : BigInt) / "20194965098495006574" == 1);
//     Assert.isTrue(("-20194965098495006574" : BigInt) / "-20194965098495006574" == 1);
//   }

//   public function testDivisionOf0Equals0() {
//     Assert.isTrue((0 : BigInt) / 1 == 0);
//     Assert.isTrue((-0 : BigInt) / 1 == 0);
//     Assert.isTrue((-0 : BigInt) / "1234567890987654321" == 0);
//     Assert.isTrue((0 : BigInt) / "-1234567890987654321" == 0);
//   }

//   public function testModulo0ThrowsError() {
//     Assert.raises(function() (0 : BigInt) % 0, Error);
//     Assert.raises(function() (-0 : BigInt) % 0, Error);
//     Assert.raises(function() (5 : BigInt) % 0, Error);
//     Assert.raises(function() (-5 : BigInt) % 0, Error);
//     Assert.raises(function() ("9549841598749874951041" : BigInt) % 0, Error);
//     Assert.raises(function() ("-20964918940987496110974948" : BigInt) % 0, Error);
//   }

//   public function testModuloHandlesSignsCorrectly() {
//     Assert.isTrue((124234233 : BigInt) % 2 == 1);
//     Assert.isTrue((124234233 : BigInt) % -2 == 1);
//     Assert.isTrue((-124234233 : BigInt) % 2 == -1);
//     Assert.isTrue((-124234233 : BigInt) % -2 == -1);
//     Assert.isTrue((2 : BigInt) % -1243233 == 2, 'excpected ${(2 : BigInt)} % ${(-1243233 : BigInt)} == 2 but got ${(2 : BigInt) % -1243233}');
//     Assert.isTrue((-2 : BigInt) % -1243233 == -2, 'excpected ${(-2 : BigInt)} % ${(-1243233 : BigInt)} == -2 but got ${(-2 : BigInt) % -1243233}');
//     Assert.isTrue(("786456456335437356436" : BigInt) % "-5423424653" == "2663036842", 'expected ${("786456456335437356436" : BigInt)} % ${("-5423424653" : BigInt)} == ${("2663036842" : BigInt)} but got ${("786456456335437356436" : BigInt) % "-5423424653"}');
//     Assert.isTrue(("93453764643534523" : BigInt) % -2342 == 1119);
//     Assert.isTrue((-32542543 : BigInt) % 100000000 == -32542543);
//   }

//   public function testPrevNext() {
//     Assert.isTrue((546 : BigInt).prev() == 545, 'expected ${(546 : BigInt)}.prev() == 545 but got ${(546 : BigInt).prev()}');
//     Assert.isTrue((1 : BigInt).prev() == 0);
//     Assert.isTrue((0 : BigInt).prev() == -1);
//     Assert.isTrue((-1 : BigInt).prev() == -2, 'expected ${(-1 : BigInt)}.prev() == -2 but got ${(-1 : BigInt).prev()}');
//     Assert.isTrue((-1987 : BigInt).prev() == -1988);

//     Assert.isTrue((546 : BigInt).next() == 547);
//     Assert.isTrue((1 : BigInt).next() == 2);
//     Assert.isTrue((0 : BigInt).next() == 1);
//     Assert.isTrue((-1 : BigInt).next() == 0);
//     Assert.isTrue((-1987 : BigInt).next() == -1986);

//     Assert.isTrue((0 : BigInt).next() == 1);
//     Assert.isTrue((-1 : BigInt).next() == 0);
//     Assert.isTrue((34 : BigInt).next() == 35);
//     Assert.isTrue(("9007199254740992" : BigInt).next() == "9007199254740993");
//     Assert.isTrue(("-9007199254740992" : BigInt).next() == "-9007199254740991");
//     Assert.isTrue(("9007199254740992999" : BigInt).next() == "9007199254740993000");
//     Assert.isTrue(("9007199254740991" : BigInt).next() == "9007199254740992");

//     Assert.isTrue((0 : BigInt).prev() == -1);
//     Assert.isTrue((-1 : BigInt).prev() == -2);
//     Assert.isTrue((34 : BigInt).prev() == 33);
//     Assert.isTrue(("9007199254740992" : BigInt).prev() == "9007199254740991");
//     Assert.isTrue(("-9007199254740992" : BigInt).prev() == "-9007199254740993");
//     Assert.isTrue(("9007199254740992999" : BigInt).prev() == "9007199254740992998");
//     Assert.isTrue(("-9007199254740991" : BigInt).prev() == "-9007199254740992");

//     Assert.isTrue(("109874981950949849811049" : BigInt).prev() == "109874981950949849811048", 'expected ${("109874981950949849811049" : BigInt).prev()} == ${("109874981950949849811048" : BigInt)}');
//     Assert.isTrue(("109874981950949849811049" : BigInt).next() == "109874981950949849811050", 'expected ${("109874981950949849811049" : BigInt).next()} == ${("109874981950949849811050" : BigInt)}');
//     Assert.isTrue(("-109874981950949849811049" : BigInt).prev() == "-109874981950949849811050", 'expected ${("-109874981950949849811049" : BigInt).prev()} == ${("-109874981950949849811050" : BigInt)}');
//     Assert.isTrue(("-109874981950949849811049" : BigInt).next() == "-109874981950949849811048", 'expected ${("-109874981950949849811049" : BigInt).next()} == ${("-109874981950949849811048" : BigInt)}');
//   }

//   public function testPrevNextCarriesOverCorrectly() {
//     Assert.isTrue((9999999 : BigInt).next() == 10000000);
//     Assert.isTrue((10000000 : BigInt).prev() == 9999999);
//   }

//   public function testAbs() {
//     Assert.isTrue((0 : BigInt).abs() == 0);
//     Assert.isTrue(("-0" : BigInt).abs() == 0);
//     Assert.isTrue((54 : BigInt).abs() == 54);
//     Assert.isTrue((-54 : BigInt).abs() == 54);
//     Assert.isTrue(("13412564654613034984065434" : BigInt).abs() == "13412564654613034984065434");
//     Assert.isTrue(("-13412564654613034984065434" : BigInt).abs() == "13412564654613034984065434");
//   }

//   public function testIsPositiveAndIsNegative() {
//     Assert.isFalse((0 : BigInt).isPositive());
//     Assert.isFalse((0 : BigInt).isNegative());
//     Assert.isFalse((-0 : BigInt).isPositive());
//     Assert.isFalse((-0 : BigInt).isNegative());
//   }

//   public function testIsPositiveAndIsNegativeWorkForSmallNumbers() {
//     Assert.isTrue((1 : BigInt).isPositive());
//     Assert.isFalse((543 : BigInt).isNegative());
//     Assert.isFalse((-1 : BigInt).isPositive());
//     Assert.isTrue((-765 : BigInt).isNegative());
//   }

//   public function testIsPositiveAndIsNegativeWorkForBigNumbers() {
//     Assert.isTrue(("651987498619879841" : BigInt).isPositive());
//     Assert.isFalse(("0054984980098460" : BigInt).isNegative());
//     Assert.isFalse(("-1961987984109078496" : BigInt).isPositive());
//     Assert.isTrue(("-98800984196109540984" : BigInt).isNegative());
//   }

//   public function testIsUnit() {
//     Assert.isTrue(BigInt.one.isUnit());
//     Assert.isTrue(BigInt.negativeOne.isUnit());
//     Assert.isFalse(BigInt.zero.isUnit());
//     Assert.isFalse((5 : BigInt).isUnit());
//     Assert.isFalse((-5 : BigInt).isUnit());
//     Assert.isFalse(("654609649089416160" : BigInt).isUnit());
//     Assert.isFalse(("-98410980984981094" : BigInt).isUnit());
//   }

//   public function testIsZero() {
//     Assert.isTrue(BigInt.zero.isZero());
//     Assert.isTrue((0 : BigInt).isZero());
//     Assert.isTrue(("-0" : BigInt).isZero());
//     Assert.isFalse((15 : BigInt).isZero());
//     Assert.isFalse((-15 : BigInt).isZero());
//     Assert.isFalse(("63213098189462109840" : BigInt).isZero());
//     Assert.isFalse(("-64343745644564564563" : BigInt).isZero());
//     Assert.isTrue((0 : BigInt).isZero());
//   }

//   public function testSquare() {
//     Assert.isTrue((0 : BigInt).square() == 0);
//     Assert.isTrue((16 : BigInt).square() == 256);
//     Assert.isTrue((-16 : BigInt).square() == 256);
//     Assert.isTrue(("65536" : BigInt).square() == "4294967296", 'expected ${("65536" : BigInt).square()} == 4294967296');
//   }

//   public function testPowerToNegativeNumbersIs0() {
//     Assert.isTrue((0 : BigInt).pow(-298) == 0);
//     Assert.isTrue((543 : BigInt).pow(-2) == 0);
//     Assert.isTrue(("323434643534523" : BigInt).pow(-1) == 0);
//     Assert.isTrue((-54302 : BigInt).pow("-543624724341214223562") == 0);
//     Assert.isTrue(("-20199605604968" : BigInt).pow(-99) == 0);

//     Assert.isTrue((1 : BigInt).pow(-1) == 1);
//     Assert.isTrue((-1 : BigInt).pow(-1) == -1);
//     Assert.isTrue((-1 : BigInt).pow(-2) == 1);
//   }

//   public function testPowerHandlesSignsCorrectly() {
//     Assert.isTrue((2 : BigInt).pow(3) == 8);
//     Assert.isTrue((-2 : BigInt).pow(3) == -8, 'expected ${(-2 : BigInt).pow(3)} == -8');
//     Assert.isTrue(("1036350201654" : BigInt).pow(4) == "1153522698998527286707879497611725813209153232656", 'expected ${("1036350201654" : BigInt).pow(4)} == ${("1153522698998527286707879497611725813209153232656" : BigInt)}');
//     Assert.isTrue(("-1036350201654" : BigInt).pow(4) == "1153522698998527286707879497611725813209153232656", 'expected ${("-1036350201654" : BigInt).pow(4)} == ${("1153522698998527286707879497611725813209153232656" : BigInt)}');
//     Assert.isTrue(("-154654987" : BigInt).pow(3) == "-3699063497752861435082803", 'expected ${("-154654987" : BigInt).pow(3)} == ${("-3699063497752861435082803" : BigInt)}');

//     Assert.isTrue((1 : BigInt).pow(1) == 1);
//     Assert.isTrue((-1 : BigInt).pow(1) == -1);
//     Assert.isTrue((-1 : BigInt).pow(2) == 1);

//     Assert.isTrue((1 : BigInt).pow("1e100") == 1);
//     Assert.isTrue((-1 : BigInt).pow("1e100") == 1);
//     Assert.isTrue((0 : BigInt).pow("1e100") == 0);
//   }

//   public function testPower() {
//     var i : BigInt = "102340001040000";
//     Assert.isTrue(("10000000000" : BigInt) == BigInt.fromInt(10).pow(10));
//   }

//   public function testPowerOf0to0is1() {
//     Assert.isTrue((0 : BigInt).pow(0) == 1);
//     Assert.isTrue((0 : BigInt).pow("-0") == 1);
//     Assert.isTrue(("-0" : BigInt).pow(0) == 1);
//     Assert.isTrue(("-0" : BigInt).pow("-0") == 1);
//   }

//   public function testPowerCarriesOverCorrectly() {
//     Assert.isTrue(("16" : BigInt).pow("13") == "4503599627370496");
//     Assert.isTrue(("123456789123456789" : BigInt).pow(10) == "822526267372365207989468699031914332476569003445489153619518989325083908083922133639704420166045905346960117046949453426283086050487204639652635846010822673782217799736601");
//     Assert.isTrue(("2" : BigInt).pow(63) == "9223372036854775808", 'expected 2.pow(63) == ${("9223372036854775808" : BigInt)} but got ${("2" : BigInt).pow(63)}');
//     Assert.isTrue((100 : BigInt).pow(56) != 0);
//   }

//   public function testDivision() {
//     Assert.raises(function() {
//       (1 : BigInt) / (0 : BigInt);
//     }, Error);
//     Assert.raises(function() {
//       (0 : BigInt) / (0 : BigInt);
//     }, Error);

//     var tests = [
//       { num : (10 : BigInt), div : (2 : BigInt), res : (5 : BigInt) },
//       { num : ("102340001040000" : BigInt), div : ("10000000000" : BigInt), res : (10234 : BigInt)},
//       { num : ("1000000000000000000" : BigInt), div : (50 : BigInt), res : ("20000000000000000" : BigInt) },
//     ];
//     for(test in tests) {
//       Assert.isTrue(test.num / test.div == test.res, 'expected ${test.num} / ${test.div} == ${test.res} and it was ${test.num / test.div}');
//     }
//   }

//   public function testAddition() {
//     var m : BigInt;
//     var n : BigInt;
//     var o : BigInt;
//     var s : BigInt;

//     // identity
//     m = 123; n = 0;
//     Assert.isTrue(m+n == m);
//     Assert.isTrue(n+m == m);

//     Assert.isTrue(m-n == m);
//     Assert.isTrue(n-m == -m);

//     // commutativity
//     m = 123; n = 343; s = 466;
//     Assert.isTrue(m+n == s);
//     Assert.isTrue(n+m == s);

//     Assert.isTrue(s-n == m);
//     Assert.isTrue(n-s == -m);

//     // associativity
//     m = -234356; n = 355321; o = 234;
//     Assert.isTrue((m+n)+o == m+(n+o));

//     Assert.isTrue((m-n)+o == m-(n-o));

//     m = 1; n = -9999; s = -9998;
//     Assert.isTrue(m+n == s);

//     Assert.isTrue(s-n == m);

//     m = "11111111111111111111110111111111111111111111111111";
//     n = m;
//     s = "22222222222222222222220222222222222222222222222222";
//     Assert.isTrue(m+n == s, 'expected $m + $n == $s but is ${m+n}');

//     Assert.isTrue((m-n).isZero(), 'expected $m-$n==0 but is ${m-n}');
//     Assert.isTrue(m-n == 0, 'expected $m - $n==0 but is ${m-n}');
//     Assert.isTrue(s-n == m, 'expected $s - $n == $m but is ${s-n}');

//     m = "99499494949383948405";
//     n = "-472435789789045237084578078029457809342597808204538970";
//     s = "-472435789789045237084578078029457709843102858820590565";
//     // FAILS
//     Assert.isTrue(m+n == s, 'expected $m + $n == $s but got ${m + n}');
//     // FAILS
//     Assert.isTrue(s-n == m, 'expected $s - $n == $m but got ${s - n}');

//     m = "-1";
//     n = "100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
//     s =  "99999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999";
//     Assert.isTrue(m+n == s, 'expected $m + $n == $s but got ${m+n}');
//     Assert.isTrue(s-n == m, 'expected $s - $n == $m but got ${s-n}');

//     m = "1";
//     Assert.isTrue(m+s == n, 'expected $m + $s == $n but got ${m+s}');
//     Assert.isTrue(n-s == m, 'expected $n - $s == $m but got ${n-s}');
//     Assert.isTrue(n-m == s, 'expected $n - $m == $s but got ${n-m}');
//   }

//   public function testMultiplication() {
//     var a : BigInt;
//     var b : BigInt;
//     var m : BigInt;

//     a = 12347; b = 0;
//     Assert.isTrue(a*b == b);
//     Assert.isTrue(b*a == b);

//     a = -99999; b = 1;
//     Assert.isTrue(a*b == a);
//     Assert.isTrue(b*a == a);

//     a = 1235; b = 44; m = 54340;
//     Assert.isTrue(a*b == m);
//     Assert.isTrue(b*a == m);

//     a = -11; b = -9; m = 99;
//     Assert.isTrue(a*b == m);

//     a = 55; b = 200395; m = 11021725;
//     Assert.isTrue(a*b == m);

//     a = "111111111111111111111111111111111111111";
//     b = "-333333333333333333333";
//     m = "-37037037037037037036999999999999999999962962962962962962963";
//     // FAILS
//     Assert.isTrue(a * b == m, 'expected $a * $b == $m but got ${a * b}');
//   }

//   public function testComparison() {
//     var a : BigInt = 1,
//         b : BigInt = 2;
//     Assert.isTrue(a < b);
//     Assert.isTrue(a <= b);
//     Assert.isTrue(a <= a);

//     Assert.isTrue(b > a);
//     Assert.isTrue(b >= a);
//     Assert.isTrue(b >= b);
//     Assert.isTrue(b <= b);

//     Assert.equals(-1, a.compareTo(b));
//     Assert.equals( 1, b.compareTo(a));
//     Assert.equals( 0, b.compareTo(b));

//     a = "-333333333333333333333";
//     b = "111111111111111111111111111111111111111";

//     // Assert.isTrue(a < b, 'expected $a < $b == true but it is ${a<b}');
//     // Assert.isTrue(a <= b, 'expected $a <= $b == true but it is ${a<=b}');
//     Assert.isTrue(a <= a);

//     Assert.isTrue(b > a);
//     Assert.isTrue(b >= a);
//     Assert.isTrue(b >= b);
//     Assert.isTrue(b <= b);

//     Assert.equals(-1, a.compareTo(b), 'expected $a.compareTo($b) t0 be -1 but it is ${a.compareTo(b)}');
//     Assert.equals( 1, b.compareTo(a));
//     Assert.equals( 0, b.compareTo(b));

//     a = "-37037037037037037036999999999999999999962962962962962962963";
//     b = "-333333333333333333333";

//     Assert.isTrue(a < b);
//     Assert.isTrue(a <= b);
//     Assert.isTrue(a <= a);

//     Assert.isTrue(b > a);
//     Assert.isTrue(b >= a);
//     Assert.isTrue(b >= b);
//     Assert.isTrue(b <= b);

//     Assert.equals(-1, a.compareTo(b));
//     Assert.equals( 1, b.compareTo(a));
//     Assert.equals( 0, a.compareTo(a));
//     Assert.equals( 0, b.compareTo(b));
//   }

//   public function testNegation() {
//     var m : BigInt;
//     var n : BigInt;

//     // -0 == 0
//     n = 0;
//     Assert.isTrue(-n == n, 'expected ${-n} == $n');

//     n = 1;
//     Assert.isTrue(-n == -1);
//     Assert.isTrue(-(-n) == n);

//     n = -1234;
//     Assert.isTrue(-n == 1234);
//     Assert.isTrue(-(-n) == n);

//     m = "192395858359234934684359234";
//     n = "-192395858359234934684359234";
//     Assert.isTrue(-m == n);
//     Assert.isTrue(m == -n);
//   }

//   public function testBigIntParsesNumbersCorrectly() {
//     Assert.isTrue(BigInt.fromStringWithBase("10", 2) == 2);
//     Assert.isTrue(BigInt.fromStringWithBase("FF", 16) == 255);
//     Assert.isTrue(BigInt.fromStringWithBase("111100001111", 2) == 3855, 'expected ${BigInt.fromStringWithBase("111100001111", 2)} == ${(3855 : BigInt)}');

//     Assert.isTrue(BigInt.fromStringWithBase("-1", 16) == -1);
//     Assert.isTrue(BigInt.fromStringWithBase("306057512216440636035370461297268629388588804173576999416776741259476533176716867465515291422477573349939147888701726368864263907759003154226842927906974559841225476930271954604008012215776252176854255965356903506788725264321896264299365204576448830388909753943489625436053225980776521270822437639449120128678675368305712293681943649956460498166450227716500185176546469340112226034729724066333258583506870150169794168850353752137554910289126407157154830282284937952636580145235233156936482233436799254594095276820608062232812387383880817049600000000000000000000000000000000000000000000000000000000000000000000000000306057512216440636035370461297268629388588804173576999416776741259476533176716867465515291422477573349939147888701726368864263907759003154226842927906974559841225476930271954604008012215776252176854255965356903506788725264321896264299365204576448830388909753943489625436053225980776521270822437639449120128678675368305712293681943649956460498166450227716500185176546469340112226034729724066333258583506870150169794168850353752137554910289126407157154830282284937952636580145235233156936482233436799254594095276820608062232812387383880817049600000000000000000000000000000000000000000000000000000000000000000000000000306057512216440636035370461297268629388588804173576999416776741259476533176716867465515291422477573349939147888701726368864263907759003154226842927906974559841225476930271954604008012215776252176854255965356903506788725264321896264299365204576448830388909753943489625436053225980776521270822437639449120128678675368305712293681943649956460498166450227716500185176546469340112226034729724066333258583506870150169794168850353752137554910289126407157154830282284937952636580145235233156936482233436799254594095276820608062232812387383880817049600000000000000000000000000000000000000000000000000000000000000000000000000", 10) == BigInt.fromStringWithBase("9822997e35bb99bcf103a64299aa92b8446ab93879fba53349f1626f3c8f78a4ee1d8d9e7562538f8e374fdf64c8eff7481c63cde5ca9821abfb3df6fb3e2489d2f85d34cf347f3e89191a19cc6b6b8072a976a8f1bcf68d20f18a1c0efb023252ba2d0961428a5c282d2645f3f7fa160f7f84aca88e40a74066c4a787bed7d0082f7e45b1ffee532715f56bd5f8168eaf7eaae112ed1316371f047692631e70e6b85b290ef063845b364dad7e10b9deb9fcfb708f83b7c3c6b82ce16eb0034c030b332a58d637a7b547fd0527051d7de9e5004db2ea2bd75f5c5a280a1a9b93c3c83373b6dcf1b65c01197096e97d13076b6613bc2ebf47c91fbe1aefeea966134bfbbf5f850320f0f0c2d88888bd82d118a6aaf8df2b092cf5456eff7e209feb476bf3c01d6d2e7ca0b9f40d83b107b4def92f2927cf0a1bb6190c67a4da91478709262ed1f1ecb77fbaf1197ac238c246a63a697f51e8d539f850e790137e7fce5f764896fdfb4fc3787520608f0400e72aeea5737c36304c6887ec1a174564ecec63a57b1e0946dc311dd3aea7bfae197ff9c7fcbf17c97d9db303d231702ef502dde1b53896196dc2e5d30b2b6ec58fc3744f4de08109eb99aa9f22ffe2f12f3953f516f91d35a8852aff4a19e250410fbd8dbcdae99f92f88e2f94341fc1ecdff32733d194c0541f708a72c5b4c03e5515e1086d0903addca0e172968ff1dee87bbd4fee679e2ee5a52975807ae7212cc2a33e0821e2d9b44eaa7dc29536a94c6597eda41bdd1e5e618e7b388b53d38ef9542523bce888738db46c6706c3ee82cbc3655408071e9e422a44d309e3cfd31ec2135ee0cba32b0c6721c8bee4d076543b71c35a06087a007c14e51d1f0c4d0aa9aa0751dfd3776d2357a010e6b147aca40c7b669291e6defbf5ca77505c960f14b330e6c90dc2539431329ef78a1e9f26b2ead7d28a622e6b586bcee22bd0a495442c6a1235588988252cbd4d36975560fb8e7e5c8cf06f29aeb68659c5cb4cf8d011375b00000000000000000000000000000000000000000000000000000000000000000000000000", 16));
//     Assert.isTrue(BigInt.fromStringWithBase("9223372036854775808", 10) == BigInt.fromStringWithBase("1000000000000000000000000000000000000000000000000000000000000000", 2));
//     Assert.isTrue(BigInt.fromStringWithBase("324AFCCC342342333CCD239998881232324AFCCC342342333CCD239998881232", 16) == "22748133857356174891035811692236022265357659892433333914058690475216129757746");
//     Assert.isTrue(BigInt.fromStringWithBase("234345345345", 10) == BigInt.fromStringWithBase("3690123141", 16));
//     Assert.isTrue(BigInt.fromStringWithBase("-10", 16) == "-16");
//   }

//   public function testBigIntOutputsNumbersCorrectly() {
//     Assert.isTrue(("366900685503779409298642816707647664013657589336" : BigInt).toStringWithBase(16) == "4044654fce69424a651af2825b37124c25094658");
//     Assert.isTrue(BigInt.fromStringWithBase("111111111111111111111111111111111111111111111111111111", 2).toStringWithBase(2) == "111111111111111111111111111111111111111111111111111111");
//     Assert.isTrue(BigInt.fromStringWithBase("secretmessage000", 36).toStringWithBase(36) == "secretmessage000");
//     Assert.isTrue((-256 : BigInt).toStringWithBase(16) == "-100");
//   }

//   public function testShiftingLeftAndRight() {
//     Assert.isTrue((-5 : BigInt).shiftRight(2) == -2);
//     Assert.isTrue((5 : BigInt).shiftRight(-2) == 20, 'expected ${(5 : BigInt).shiftRight(-2)} == 20');
//     Assert.isTrue((5 : BigInt).shiftLeft(-2) == 1);
//     Assert.isTrue((1024 : BigInt).shiftLeft(100) == "1298074214633706907132624082305024", 'expected ${(1024 : BigInt)}.shiftLeft(100) == ${("1298074214633706907132624082305024" : BigInt)} but got ${(1024 : BigInt).shiftLeft(100)}');
//     Assert.isTrue(("2596148429267413814265248164610049" : BigInt).shiftRight(100) == 2048);
//     Assert.isTrue(("8589934592" : BigInt).shiftRight(-50) == "9671406556917033397649408");
//     Assert.isTrue(("38685626227668133590597632" : BigInt).shiftLeft(-50) == "34359738368");
//     Assert.isTrue(("-1" : BigInt).shiftRight(25) == -1);
//   }

//   public function testBitwiseOperations() {
//     Assert.isTrue(("435783453" : BigInt) & "902345074" == "298352912", 'expected ${("435783453" : BigInt) & "902345074"} to be 298352912');
//     Assert.isTrue(("435783453" : BigInt) | "902345074" == "1039775615");
//     Assert.isTrue(("435783453" : BigInt) ^ "902345074" == "741422703");
//     Assert.isTrue(~("94981987261387596" : BigInt) == "-94981987261387597");
//     Assert.isTrue(("-6931047708307681506" : BigInt) ^ "25214903917" == "-6931047723896018573");
//     Assert.isTrue(("-6931047723896018573" : BigInt) & "281474976710655" == "273577603885427");
//     Assert.isTrue(("-65" : BigInt) ^ "-42" == "105");
//     Assert.isTrue(("6" : BigInt) & "-3" == "4");
//     Assert.isTrue(~("0" : BigInt) == "-1");
//     Assert.isTrue(("13" : BigInt) | -8 == "-3");
//     Assert.isTrue(("12" : BigInt) ^ -5 == "-9");
//   }

//   public function testIsEvenAndIsOdd() {
//     Assert.isTrue((0 : BigInt).isEven());
//     Assert.isFalse((0 : BigInt).isOdd());

//     Assert.isTrue((654 : BigInt).isEven());
//     Assert.isFalse((654 : BigInt).isOdd());

//     Assert.isTrue((653 : BigInt).isOdd());
//     Assert.isFalse((653 : BigInt).isEven());

//     Assert.isTrue((-984 : BigInt).isEven());
//     Assert.isFalse((-984 : BigInt).isOdd());

//     Assert.isTrue((-987 : BigInt).isOdd());
//     Assert.isFalse((-987 : BigInt).isEven());

//     Assert.isTrue(("9888651888888888" : BigInt).isEven());
//     Assert.isFalse(("9888651888888888" : BigInt).isOdd());

//     Assert.isTrue(("1026377777777777" : BigInt).isOdd());
//     Assert.isFalse(("1026377777777777" : BigInt).isEven());

//     Assert.isTrue(("-9888651888888888" : BigInt).isEven());
//     Assert.isFalse(("-9888651888888888" : BigInt).isOdd());

//     Assert.isTrue(("-1026377777777777" : BigInt).isOdd());
//     Assert.isFalse(("-1026377777777777" : BigInt).isEven());
//   }
}
