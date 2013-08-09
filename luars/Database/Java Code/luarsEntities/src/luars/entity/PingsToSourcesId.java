package luars.entity;
// Generated Feb 15, 2012 9:15:19 AM by Hibernate Tools 3.2.1.GA



/**
 * PingsToSourcesId generated by hbm2java
 */
public class PingsToSourcesId  implements java.io.Serializable {


     private int pingId;
     private int sourceId;

    public PingsToSourcesId() {
    }

    public PingsToSourcesId(int pingId, int sourceId) {
       this.pingId = pingId;
       this.sourceId = sourceId;
    }
   
    public int getPingId() {
        return this.pingId;
    }
    
    public void setPingId(int pingId) {
        this.pingId = pingId;
    }
    public int getSourceId() {
        return this.sourceId;
    }
    
    public void setSourceId(int sourceId) {
        this.sourceId = sourceId;
    }


   public boolean equals(Object other) {
         if ( (this == other ) ) return true;
		 if ( (other == null ) ) return false;
		 if ( !(other instanceof PingsToSourcesId) ) return false;
		 PingsToSourcesId castOther = ( PingsToSourcesId ) other; 
         
		 return (this.getPingId()==castOther.getPingId())
 && (this.getSourceId()==castOther.getSourceId());
   }
   
   public int hashCode() {
         int result = 17;
         
         result = 37 * result + this.getPingId();
         result = 37 * result + this.getSourceId();
         return result;
   }   


}


