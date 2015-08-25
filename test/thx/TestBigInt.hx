package thx;

import utest.Assert;
import thx.BigInt;

// TODO add tests for greater(Equal)/less(Equal)
class TestBigInt {
  public function new() {}

  public function testCanHandleLargeNumbers() {
    var tenFactorial = "3628800",
        hundredFactorial = "93326215443944152681699238856266700490715968264381621468592963895217599993229915608941463976156518286253697920827223758251185210916864000000000000000000000000",
        threeToTenThousand = "16313501853426258743032567291811547168121324535825379939348203261918257308143190787480155630847848309673252045223235795433405582999177203852381479145368112501453192355166224391025423628843556686559659645012014177448275529990373274425446425751235537341867387607813619937225616872862016504805593174059909520461668500663118926911571773452255850626968526251879139867085080472539640933730243410152186914328917354576854457274195562218013337745628502470673059426999114202540773175988199842487276183685299388927825296786440252999444785694183675323521704432195785806270123388382931770198990841300861506996108944782065015163410344894945809337689156807686673462563038164792190665340124344133980763205594364754963451564072340502606377790585114123814919001637177034457385019939060232925194471114235892978565322415628344142184842892083466227875760501276009801530703037525839157893875741192497705300469691062454369926795975456340236777734354667139072601574969834312769653557184396147587071260443947944862235744459711204473062937764153770030210332183635531818173456618022745975055313212598514429587545547296534609597194836036546870491771927625214352957503454948403635822345728774885175809500158451837389413798095329711993092101417428406774326126450005467888736546254948658602484494535938888656542746977424368385335496083164921318601934977025095780370104307980276356857350349205866078371806065542393536101673402017980951598946980664330391505845803674248348878071010412918667335823849899623486215050304052577789848512410263834811719236949311423411823585316405085306164936671137456985394285677324771775046050970865520893596151687017153855755197348199659070192954771308347627111052471134476325986362838585959552209645382089055182871854866744633737533217524880118401787595094060855717010144087136495532418544241489437080074716158404895914136451802032446707961058757633345691696743293869623745410870051851590672859347061212573446572045088465460616826082579731686004585218284333452396157730036306379421822435818001505905203918209206969662326706952623512427380240468784114535101496733983401240219840048956733689309620321613793757156727562461651933397540266795963865921590913322060572673349849253303397874242381960775337182730037783698708748781738419747698880321601186310506332869704931303076839444790968339306301273371014087248060946851793697973114432706759288546077622831002526800554849696867710280945946603669593797354642136622231192695027321229511912952940320879763123151760555959496961163141455688278842949587288399100273691880018774147568892650186152065335219113072582417699616901995530249937735219099786758954892534365835235843156112799728164123461219817343904782402517111603206575330527850752564642995318064985900815557979945885931124351303252811255254295797082281946658798705979077492469849644183166585950844953164726896146168297808178398470451561320526180542310840744843107469368959707726836608471817060598771730170755446473440774031371227437651048421606224757527085958515947273151027400662948161111284777828103531499488913672800783167888051177155427285103861736658069404797695900758820465238673970882660162285107599221418743657006872537842677883708807515850397691812433880561772652364847297019508025848964833883225165668986935081274596293983121864046277268590401580209059988500511262470167150495261908136688693861324081559046336288963037090312033522400722360882494928182809075406914319957044927504420797278117837677431446979085756432990753582588102440240611039084516401089948868433353748444104639734074519165067632941419347985624435567342072815910754484123812917487312938280670403228188813003978384081332242484646571417574404852962675165616101527367425654869508712001788393846171780457455963045764943565964887518396481296159902471996735508854292964536796779404377230965723361625182030798297734785854606060323419091646711138678490928840107449923456834763763114226000770316931243666699425694828181155048843161380832067845480569758457751090640996007242018255400627276908188082601795520167054701327802366989747082835481105543878446889896230696091881643547476154998574015907396059478684978574180486798918438643164618541351689258379042326487669479733384712996754251703808037828636599654447727795924596382283226723503386540591321268603222892807562509801015765174359627788357881606366119032951829868274617539946921221330284257027058653162292482686679275266764009881985590648534544939224296689791195355783205968492422636277656735338488299104238060289209390654467316291591219712866052661347026855261289381236881063068219249064767086495184176816629077103667131505064964190910450196502178972477361881300608688593782509793781457170396897496908861893034634895715117114601514654381347139092345833472226493656930996045016355808162984965203661519182202145414866559662218796964329217241498105206552200001";
    function factorial(n : BigInt) : BigInt {
      if (n == 0 || n == 1) {
        return 1;
      }
      return factorial(n.prev()) * n;
    }

    Assert.isTrue(factorial(10) == tenFactorial);
    Assert.isTrue(factorial(100) == hundredFactorial);

    // TODO
    //Assert.isTrue((3 : BigInt).pow(10000) == threeToTenThousand);
  }

  public function testIsImmutable() {
    var n : BigInt = 14930352;
    n.add(9227465);
    Assert.isTrue(n == 14930352);
    n.subtract(123456);
    Assert.isTrue(n == 14930352);
  }

  public function testInts() {
    var tests = [
          1, 2, 4, 8, 16, 32, 64, 128, 256,
          512, 1024, 2048, 4096, 10000, 100000,
          1000000, 10000000
        ];
    for(test in tests) {
      var out : BigInt = test;
      Assert.equals(test, out.toInt(), 'expected $test but got ${out.toInt()}');

      var out : BigInt = -test;
      Assert.equals(-test, out.toInt(), 'expected ${-test} but got ${out.toInt()}');
    }
  }

  public function testFloats() {
    var tests = [0.0, 1.0, 5.0, 1.234e63, 5.432e80, 0.00001, 1.2345e-50];

    for(test in tests) {
      var out : BigInt = test;
      Assert.floatEquals(test, out.toFloat(), 'expected $test but got ${out.toFloat()}');

      var out : BigInt = -test;
      Assert.floatEquals(-test, out.toFloat(), 'expected ${-test} but got ${out.toFloat()}');
    }
  }

  public function testStrings() {
    var tests = ["0", "3", "20",
                 "12345678901234567890",
                 "999999999999999999"
                ];

    for(test in tests) {
      var out : BigInt = test;
      Assert.equals(test, out.toString(), 'expected $test but got ${out.toString()}');

      if(test == "0")
        continue;

      var out : BigInt = '-$test';
      Assert.equals('-$test', out.toString(), 'expected -$test but got ${out.toString()}');
    }
  }

  public function testEquals() {
    Assert.isTrue((0 : BigInt) == (0 : BigInt));
    Assert.isTrue((1 : BigInt) == (1 : BigInt));
    Assert.isTrue(("12345678901234567890" : BigInt) == ("12345678901234567890" : BigInt));
    Assert.isTrue((-1 : BigInt) == (-1 : BigInt));
    Assert.isTrue(("-12345678901234567890" : BigInt) == ("-12345678901234567890" : BigInt));

    Assert.isFalse((0 : BigInt) != (0 : BigInt));
    Assert.isFalse((1 : BigInt) != (1 : BigInt));
    Assert.isFalse(("12345678901234567890" : BigInt) != ("12345678901234567890" : BigInt));
    Assert.isFalse((-1 : BigInt) != (-1 : BigInt));
    Assert.isFalse(("-12345678901234567890" : BigInt) != ("-12345678901234567890" : BigInt));
    Assert.isTrue(("-12345678901234567890" : BigInt) != ("12345678901234567890" : BigInt));

    Assert.isTrue((0 : BigInt) != (1 : BigInt));
    Assert.isTrue((1 : BigInt) != (2 : BigInt));
    Assert.isTrue(("12345678901234567890" : BigInt) != ("12345678901234567891" : BigInt));
    Assert.isTrue((-1 : BigInt) != (-2 : BigInt));
    Assert.isTrue(("-12345678901234567890" : BigInt) != ("-12345678901234567891" : BigInt));

    Assert.isFalse((0 : BigInt) == (1 : BigInt));
    Assert.isFalse((1 : BigInt) == (2 : BigInt));
    Assert.isFalse(("12345678901234567890" : BigInt) == ("12345678901234567891" : BigInt));
    Assert.isFalse((-1 : BigInt) == (-2 : BigInt));
    Assert.isTrue((2 : BigInt) != (-2 : BigInt));
    Assert.isFalse((2 : BigInt) == (-2 : BigInt));
    Assert.isFalse(("-12345678901234567890" : BigInt) == ("-12345678901234567891" : BigInt));

    Assert.isTrue((0 : BigInt) == ("-0" : BigInt));
  }

  public function testIgnoreLeadingZeros() {
    Assert.isTrue(("0000000000" : BigInt) == "0");
    Assert.isTrue(("000000000000023" : BigInt) == 23);
    Assert.isTrue(("-0000000000000000000000123" : BigInt) == -123, 'expected ${("-0000000000000000000000123" : BigInt)} == ${(-123 : BigInt)} to be true');
  }

  public function testNumbersShouldBeTheSameWhenConstructedDifferently() {
    Assert.isTrue(("12e5" : BigInt) == 12e5, 'expected ${("12e5" : BigInt)} == ${(12e5 : BigInt)} to be true');
    Assert.isTrue((12e5 : BigInt) == "1200000", 'expected ${(12e5 : BigInt)} == ${("1200000" : BigInt)} to be true');
    Assert.isTrue(("1" : BigInt) == 1, 'expected ${("1" : BigInt)} == ${(1 : BigInt)} to be true');
    Assert.isTrue((12345 : BigInt) == "12345", 'expected ${(12345 : BigInt)} == ${("12345" : BigInt)} to be true');
    Assert.isTrue(("9876543210" : BigInt) == 9876543210, 'expected ${("9876543210" : BigInt)} == ${(9876543210 : BigInt)} to be true');
  }

  public function testFibonacci() {
    var fibs : Array<BigInt> = ["1", "1", "2", "3", "5", "8", "13", "21", "34", "55", "89", "144", "233", "377", "610", "987", "1597", "2584", "4181", "6765", "10946", "17711", "28657", "46368", "75025", "121393", "196418", "317811", "514229", "832040", "1346269", "2178309", "3524578", "5702887", "9227465", "14930352", "24157817", "39088169", "63245986", "102334155", "165580141", "267914296", "433494437", "701408733", "1134903170", "1836311903", "2971215073", "4807526976", "7778742049", "12586269025"];
    var number : BigInt = 1;
    var last : BigInt = 1;

    for (i in 2...50) {
      number = number + last;
      last = number - last;
      Assert.isTrue(number == fibs[i]);
    }
  }

  public function testCarriesOverCorrectly() {
    Assert.isTrue(("9007199254740991" : BigInt) + 1 == "9007199254740992");
    Assert.isTrue(("999999999999999999999000000000000000000000" : BigInt) + "1000000000000000000000" == "1e42");
    Assert.isTrue(("1e20" : BigInt) + "9007199254740972" == "100009007199254740972");
    Assert.isTrue(("-9007199254740983" : BigInt) + "-9999999999999998" == "-19007199254740981");
    Assert.isTrue(("100000000000000000000000000000000000" : BigInt) - "999999999999999999" == "99999999999999999000000000000000001");

    Assert.isTrue(("50000005000000" : BigInt) * "10000001" == "500000100000005000000");
  }

  public function testMisc() {
    Assert.isTrue(("10" : BigInt) + 10 == "20");
    Assert.isTrue(("-10000000000000000" : BigInt) + "0" == "-10000000000000000");
    Assert.isTrue(("0" : BigInt) + "10000000000000000" == "10000000000000000");
    Assert.isTrue((9999999 : BigInt) + 1 == 10000000);
    Assert.isTrue((10000000 : BigInt) - 1 == 9999999);
    Assert.isTrue(("-1000000000000000000000000000000000001" : BigInt) + "1000000000000000000000000000000000000" == -1);
    Assert.isTrue(("100000000000000000002222222222222222222" : BigInt) - "100000000000000000001111111111111111111" == "1111111111111111111");
    Assert.isTrue(("1" : BigInt) + "0" == "1");
    Assert.isTrue(("10" : BigInt) + "10000000000000000" == "10000000000000010");
    Assert.isTrue(("10000000000000000" : BigInt) + "10" == "10000000000000010");
    Assert.isTrue(("10000000000000000" : BigInt) + "10000000000000000" == "20000000000000000");
  }

  public function testHandlesSignsCorectly() {
    Assert.isTrue((100 : BigInt) * 100 == 10000);
    Assert.isTrue((100 : BigInt) * -100 == -10000);
    Assert.isTrue((-100 : BigInt) * 100 == -10000);
    Assert.isTrue((-100 : BigInt) * -100 == 10000);

    Assert.isTrue((13579 : BigInt) * "163500573666152634716420931676158" == "2220174289812686626814279831230549482");
    Assert.isTrue((13579 : BigInt) * "-163500573666152634716420931676158" == "-2220174289812686626814279831230549482");
    Assert.isTrue((-13579 : BigInt) * "163500573666152634716420931676158" == "-2220174289812686626814279831230549482");
    Assert.isTrue((-13579 : BigInt) * "-163500573666152634716420931676158" == "2220174289812686626814279831230549482");
    Assert.isTrue(("163500573666152634716420931676158" : BigInt) * 13579 == "2220174289812686626814279831230549482");
    Assert.isTrue(("163500573666152634716420931676158" : BigInt) * -13579 == "-2220174289812686626814279831230549482");
    Assert.isTrue(("-163500573666152634716420931676158" : BigInt) * 13579 == "-2220174289812686626814279831230549482");
    Assert.isTrue(("-163500573666152634716420931676158" : BigInt) * -13579 == "2220174289812686626814279831230549482");
    Assert.isTrue(("163500573666152634716420931676158" : BigInt) * -1 == "-163500573666152634716420931676158");
    Assert.isTrue(("1234567890987654321" : BigInt) * "132435465768798" == "163500573666152634716420931676158");
    Assert.isTrue(("1234567890987654321" : BigInt) * "-132435465768798" == "-163500573666152634716420931676158");
    Assert.isTrue(("-1234567890987654321" : BigInt) * "132435465768798" == "-163500573666152634716420931676158");
    Assert.isTrue(("-1234567890987654321" : BigInt) * "-132435465768798" == "163500573666152634716420931676158");
  }

  public function testDivisionBy1IsTheIdentity() {
    Assert.isTrue((1 : BigInt) / 1 == 1);
    Assert.isTrue((-1 : BigInt) / 1 == -1);
    Assert.isTrue((1 : BigInt) / -1 == -1);
    Assert.isTrue((153 : BigInt) / 1 == 153);
    Assert.isTrue((-153 : BigInt) / 1 == -153);
    Assert.isTrue(("9844190321790980841789" : BigInt) / 1 == "9844190321790980841789");
    Assert.isTrue(("-9844190321790980841789" : BigInt) / 1 == "-9844190321790980841789");
  }

  public function testDivisionBySelfIs1() {
    Assert.isTrue((5 : BigInt) / 5 == 1);
    Assert.isTrue((-5 : BigInt) / -5 == 1);
    Assert.isTrue(("20194965098495006574" : BigInt) / "20194965098495006574" == 1);
    Assert.isTrue(("-20194965098495006574" : BigInt) / "-20194965098495006574" == 1);
  }

  public function testDivisionOf0Equals0() {
    Assert.isTrue((0 : BigInt) / 1 == 0);
    Assert.isTrue((-0 : BigInt) / 1 == 0);
    Assert.isTrue((-0 : BigInt) / "1234567890987654321" == 0);
    Assert.isTrue((0 : BigInt) / "-1234567890987654321" == 0);
  }
  public function testDivision() {
    Assert.raises(function() {
      (1 : BigInt) / (0 : BigInt);
    }, Error);
    Assert.raises(function() {
      (0 : BigInt) / (0 : BigInt);
    }, Error);

    var tests = [
      { num : (10 : BigInt), div : (2 : BigInt), res : (5 : BigInt) },
      // FAILS
      { num : ("1000000000000000000" : BigInt), div : (50 : BigInt), res : ("20000000000000000" : BigInt) },
    ];
    for(test in tests) {
      Assert.isTrue(test.num / test.div == test.res, 'expected ${test.num} / ${test.div} == ${test.res} and it was ${test.num / test.div}');
    }
  }

  public function testAddition() {
    var m : BigInt;
    var n : BigInt;
    var o : BigInt;
    var s : BigInt;

    // identity
    m = 123; n = 0;
    Assert.isTrue(m+n == m);
    Assert.isTrue(n+m == m);

    Assert.isTrue(m-n == m);
    Assert.isTrue(n-m == -m);

    // commutativity
    m = 123; n = 343; s = 466;
    Assert.isTrue(m+n == s);
    Assert.isTrue(n+m == s);

    Assert.isTrue(s-n == m);
    Assert.isTrue(n-s == -m);

    // associativity
    m = -234356; n = 355321; o = 234;
    Assert.isTrue((m+n)+o == m+(n+o));

    Assert.isTrue((m-n)+o == m-(n-o));

    m = 1; n = -9999; s = -9998;
    Assert.isTrue(m+n == s);

    Assert.isTrue(s-n == m);

    m = "11111111111111111111110111111111111111111111111111";
    n = m;
    s = "22222222222222222222220222222222222222222222222222";
    Assert.isTrue(m+n == s, 'expected $m + $n == $s but is ${m+n}');

    Assert.isTrue((m-n).isZero(), 'expected $m-$n==0 but is ${m-n}');
    Assert.isTrue(m-n == 0, 'expected $m - $n==0 but is ${m-n}');
    Assert.isTrue(s-n == m, 'expected $s - $n == $m but is ${s-n}');

    m = "99499494949383948405";
    n = "-472435789789045237084578078029457809342597808204538970";
    s = "-472435789789045237084578078029457709843102858820590565";
    // FAILS
    Assert.isTrue(m+n == s, 'expected $m + $n == $s but got ${m + n}');
    // FAILS
    Assert.isTrue(s-n == m, 'expected $s - $n == $m but got ${s - n}');

    m = "-1";
    n = "100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
    s =  "99999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999";
    // FAILS
    Assert.isTrue(m+n == s, 'expected $m + $n == $s but got ${m+n}');
    // FAILS
    Assert.isTrue(s-n == m, 'expected $s - $n == $m but got ${s-n}');

    m = "1";
    // FAILS
    Assert.isTrue(m+s == n, 'expected $m + $s == $n but got ${m+s}');
    // FAILS
    Assert.isTrue(n-s == m, 'expected $n - $s == $m but got ${n-s}');
    // FAILS
    Assert.isTrue(n-m == s, 'expected $n - $m == $s but got ${n-m}');
  }

  public function testNegation() {
    var m : BigInt;
    var n : BigInt;

    // -0 == 0
    n = 0;
    Assert.isTrue(-n == n);

    n = 1;
    Assert.isTrue(-n == -1);
    Assert.isTrue(-(-n) == n);

    n = -1234;
    Assert.isTrue(-n == 1234);
    Assert.isTrue(-(-n) == n);

    m = "192395858359234934684359234";
    n = "-192395858359234934684359234";
    Assert.isTrue(-m == n);
    Assert.isTrue(m == -n);
  }

  public function testMultiplication() {
    var a : BigInt;
    var b : BigInt;
    var m : BigInt;

    a = 12347; b = 0;
    Assert.isTrue(a*b == b);
    Assert.isTrue(b*a == b);

    a = -99999; b = 1;
    Assert.isTrue(a*b == a);
    Assert.isTrue(b*a == a);

    a = 1235; b = 44; m = 54340;
    Assert.isTrue(a*b == m);
    Assert.isTrue(b*a == m);

    a = -11; b = -9; m = 99;
    Assert.isTrue(a*b == m);

    a = 55; b = 200395; m = 11021725;
    Assert.isTrue(a*b == m);

    a = "111111111111111111111111111111111111111";
    b = "-333333333333333333333";
    m = "-37037037037037037036999999999999999999962962962962962962963";
    // FAILS
    Assert.isTrue(a * b == m, 'expected $a * $b == $m but got ${a * b}');
  }

  public function testComparison() {
    var a : BigInt = 1,
        b : BigInt = 2;
    Assert.isTrue(a < b);
    Assert.isTrue(a <= b);
    Assert.isTrue(a <= a);

    Assert.isTrue(b > a);
    Assert.isTrue(b >= a);
    Assert.isTrue(b >= b);
    Assert.isTrue(b <= b);

    Assert.equals(-1, a.compare(b));
    Assert.equals( 1, b.compare(a));
    Assert.equals( 0, b.compare(b));

    a = "-333333333333333333333";
    b = "111111111111111111111111111111111111111";

    Assert.isTrue(a < b, 'expected $a < $b == true but it is ${a<b}');
    Assert.isTrue(a <= b, 'expected $a <= $b == true but it is ${a<=b}');
    Assert.isTrue(a <= a);

    Assert.isTrue(b > a);
    Assert.isTrue(b >= a);
    Assert.isTrue(b >= b);
    Assert.isTrue(b <= b);

    Assert.equals(-1, a.compare(b), 'expected $a.compare($b) t0 be -1 but it is ${a.compare(b)}');
    Assert.equals( 1, b.compare(a));
    Assert.equals( 0, b.compare(b));

    a = "-37037037037037037036999999999999999999962962962962962962963";
    b = "-333333333333333333333";

    Assert.isTrue(a < b);
    Assert.isTrue(a <= b);
    Assert.isTrue(a <= a);

    Assert.isTrue(b > a);
    Assert.isTrue(b >= a);
    Assert.isTrue(b >= b);
    Assert.isTrue(b <= b);

    Assert.equals(-1, a.compare(b));
    Assert.equals( 1, b.compare(a));
    Assert.equals( 0, a.compare(a));
    Assert.equals( 0, b.compare(b));
  }
}
