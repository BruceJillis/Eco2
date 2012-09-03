package engine.goods 
{
	/**
	 * ...
	 * @author 
	 */
	public class Good {
		public var cost:Number;
		public var amount:Number;
		public var fluctuation:Number = 5.0;
		public var unit:String;
		public var name:String;
		public var plural:String;
		public var rarity:Number = 1.0;
		public var has:uint = 0;
		public var sell:Number = 0;
		
		public function Good() {
			

		}
		
		public function getImg():Class {
			return null;
		}
		
	}

}