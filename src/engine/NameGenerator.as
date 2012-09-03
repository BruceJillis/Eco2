package engine {
	public class NameGenerator {
		public static var cities:Array = [
			'Zallwegle',
			'Dinkywankle',
			'Wonderswan',
			'Weer Waar'
		];
			
		public function NameGenerator() {
			
		}
		
		static public function generate(prefix:String = '', suffix:String = ''):String {
			return NameGenerator.getName(3, 10, prefix, suffix);
		}
		static private function rnd(minv:int, maxv:int):int {
		if (maxv < minv) return 0;
		return Math.floor(Math.random()*(maxv-minv+1)) + minv;
	}

	static private function getName(minlength:int, maxlength:int, prefix:String, suffix:String):String {
		prefix = prefix || '';
		suffix = suffix || '';
		//these weird character sets are intended to cope with the nature of English (e.g. char 'x' pops up less frequently than char 's')
		//note: 'h' appears as consonants and vocals
		var vocals:String = 'aeiouyh' + 'aeiou' + 'aeiou';
		var cons:String = 'bcdfghjklmnpqrstvwxz' + 'bcdfgjklmnprstvw' + 'bcdfgjklmnprst';
		var allchars:String = vocals + cons;
		//minlength += prefix.length;
		//maxlength -= suffix.length;
		var length:int = NameGenerator.rnd(minlength, maxlength) - prefix.length - suffix.length;
		if (length < 1) length = 1;
		//alert(minlength + ' ' + maxlength + ' ' + length);
		var consnum:int = 0;
		//alert(prefix);
		/*if ((prefix.length > 1) && (cons.indexOf(prefix[0]) != -1) && (cons.indexOf(prefix[1]) != -1)) {
			//alert('a');
			consnum = 2;
		}*/
		if (prefix.length > 0) {
			for (i = 0; i < prefix.length; i++) {
				if (consnum == 2) consnum = 0;
				if (cons.indexOf(prefix[i]) != -1) {
					consnum++;
				}
			}
		}
		else {
			consnum = 1;
		}
		
		var name:String = prefix;
		
		for (var i:int = 0; i < length; i++)
		{
			var touse:String;
			//if we have used 2 consonants, the next char must be vocal.
			if (consnum == 2)
			{
				touse = vocals;
				consnum = 0;
			}
			else touse = allchars;
			//pick a random character from the set we are goin to use.
			var c:String = touse.charAt(NameGenerator.rnd(0, touse.length - 1));
			name = name + c;
			if (cons.indexOf(c) != -1) consnum++;
		}
		name = name.charAt(0).toUpperCase() + name.substring(1, name.length) + suffix;
		return name;
	}			
	}
}