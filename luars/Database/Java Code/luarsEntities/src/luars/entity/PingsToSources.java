package luars.entity;
// Generated Feb 15, 2012 9:15:19 AM by Hibernate Tools 3.2.1.GA



/**
 * PingsToSources generated by hbm2java
 */
public class PingsToSources  implements java.io.Serializable {


     private PingsToSourcesId id;
     private Sources sources;
     private Pings pings;
     private double timeStart;
     private Boolean confirmed;

    public PingsToSources() {
    }

	
    public PingsToSources(PingsToSourcesId id, Sources sources, Pings pings, double timeStart) {
        this.id = id;
        this.sources = sources;
        this.pings = pings;
        this.timeStart = timeStart;
    }
    public PingsToSources(PingsToSourcesId id, Sources sources, Pings pings, double timeStart, Boolean confirmed) {
       this.id = id;
       this.sources = sources;
       this.pings = pings;
       this.timeStart = timeStart;
       this.confirmed = confirmed;
    }
   
    public PingsToSourcesId getId() {
        return this.id;
    }
    
    public void setId(PingsToSourcesId id) {
        this.id = id;
    }
    public Sources getSources() {
        return this.sources;
    }
    
    public void setSources(Sources sources) {
        this.sources = sources;
    }
    public Pings getPings() {
        return this.pings;
    }
    
    public void setPings(Pings pings) {
        this.pings = pings;
    }
    public double getTimeStart() {
        return this.timeStart;
    }
    
    public void setTimeStart(double timeStart) {
        this.timeStart = timeStart;
    }
    public Boolean getConfirmed() {
        return this.confirmed;
    }
    
    public void setConfirmed(Boolean confirmed) {
        this.confirmed = confirmed;
    }




}


