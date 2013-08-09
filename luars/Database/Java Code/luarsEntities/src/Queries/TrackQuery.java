/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Queries;

import java.util.*;
import luars.entity.Tracks;
import luars.util.HibernateUtil;
import org.hibernate.HibernateException;
import org.hibernate.Query;
import org.hibernate.*;
import org.hibernate.criterion.*;
import org.hibernate.type.Type;

/**
 *
 * @author David Reed
 */
public class TrackQuery {

    Session session;
    Criteria criteria;

    public TrackQuery() {
        session = HibernateUtil.getSessionFactory().
                openSession();
        session.beginTransaction();

        criteria = session.createCriteria(Tracks.class).
                setResultTransformer(Criteria.DISTINCT_ROOT_ENTITY);
    }

    public void byID(double trackID) {
        this.byID(new double[]{trackID});
    }

    public void byID(double[] tempIDs) {
        Integer[] trackIDs = new Integer[tempIDs.length];
        for (int ii = 0; ii < tempIDs.length; ii++) {
            trackIDs[ii] = new Integer((int) tempIDs[ii]);
        }
        criteria.add(Restrictions.in("trackId", (Integer[]) trackIDs));
    }

    public void byName(String trackName) {
        criteria.add(Restrictions.eq("t.name", trackName));
    }

    public void byDate(Date dateStart, Date dateStop) {
        criteria.createAlias("pings", "p").
                add(Restrictions.between("p.startTime", dateStart, dateStop));
    }    

    public List getTracks() {

        List resultList = new ArrayList();
        try {
            resultList = criteria.list();

            session.getTransaction().
                    commit();
        } catch (HibernateException he) {
            he.printStackTrace();
        } finally {
            return resultList;
        }
    }

    public void closeSession() {

        session.close();
    }

    public static void main(String[] args) {
      

    }
}
