package edu.pitt.math.jhol.core;

import edu.pitt.math.jhol.caml.CamlObject;
import edu.pitt.math.jhol.caml.CamlType;

/**
 * Theorem
 */
public abstract class Theorem extends CamlObject {
	/**
	 * Returns the corresponding Caml type (theorem)
	 */
	public final CamlType camlType() {
		return CamlType.THM;
	}
	
	
	/**
	 * Creates an arbitrary theorem
	 */
	public static Theorem mk_theorem(String name, Term concl) {
		return new NamedTheorem(name, concl, false);
	}
	
	
	/**
	 * Theorem's name
	 * @return
	 */
	public abstract String name();
	
	
	/**
	 * Theorem's conclusion
	 */
	public abstract Term concl();
	
	
	/**
	 * Returns true if the theorem has assumptions
	 */
	public abstract boolean hyp();
	
	
	/**
	 * Theorem with a fixed name
	 */
	public static class NamedTheorem extends Theorem {
		private final String name;
		private final Term concl;
		
		private final boolean hyps;
		
		
		private NamedTheorem(String name, Term concl, boolean hyps) {
			this.name = name;
			this.concl = concl;
			this.hyps = hyps;
		}
		
		@Override
		public String name() {
			return name;
		}
		
		@Override
		public Term concl() {
			return concl;
		}
		
		@Override
		public boolean hyp() {
			return hyps;
		}
		
		
		@Override
		public String makeCamlCommand() {
			// The name of the theorem is the name of the corresponding Caml object
			return name;
		}
		
		@Override
		public String toCommandString() {
			return name;
		}		
		
		
		/* Object methods */
		
		@Override
		public int hashCode() {
			return name.hashCode() + 59 * concl.hashCode();
		}
		
		@Override
		public boolean equals(Object obj) {
			if (this == obj)
				return true;
			if (obj == null)
				return false;
			if (!(obj instanceof NamedTheorem))
				return false;
			
			NamedTheorem obj2 = (NamedTheorem) obj;
			return name.equals(obj2.name) && concl.equals(obj2.concl) && hyps == obj2.hyps;
		}
		
		
		@Override
		public String toString() {
			StringBuilder str = new StringBuilder();
			str.append(name);
			str.append(" = ");
			str.append("|- ");
			str.append(concl);
			
			return str.toString();
		}
	}
	
	
	/**
	 * A temporary theorem
	 */
	public static class TempTheorem extends Theorem {
		private final Term cachedConcl;
		private final boolean hyps;
		
		// FIXME: command should be immutable
		private CamlObject.CamlApplication command;
		private final String tmpName;
		
		private static int nameCounter = 1;
		
		public TempTheorem(Term concl, boolean hyps) {
			this.cachedConcl = concl;
			this.hyps = hyps;
			this.tmpName = "?tmp:" + nameCounter++;
		}
		
		
		public void setCommand(CamlObject.CamlApplication command) {
			this.command = command;
		}
		
		
		@Override
		public String name() {
			return tmpName;
		}
		
		@Override
		public Term concl() {
			return cachedConcl;
		}
		
		@Override
		public boolean hyp() {
			return hyps;
		}
		
		
		@Override
		public String makeCamlCommand() {
			return command.makeCamlCommand();
		}
		
		@Override
		public String toCommandString() {
			return command.toCommandString();
		}
		
		
		/* Object methods */
		
		@Override
		public int hashCode() {
			return command.hashCode() + 59 * cachedConcl.hashCode();
		}
		
		@Override
		public boolean equals(Object obj) {
			if (this == obj)
				return true;
			if (obj == null)
				return false;
			if (!(obj instanceof TempTheorem))
				return false;
			
			TempTheorem obj2 = (TempTheorem) obj;
			return cachedConcl.equals(obj2.cachedConcl) && command.equals(obj2.command);
		}
		
		
		@Override
		public String toString() {
			StringBuilder str = new StringBuilder();
			str.append("???");
			str.append(" = ");
			str.append("|- ");
			str.append(cachedConcl);
			
			return str.toString();
		}		
		
	}
}
