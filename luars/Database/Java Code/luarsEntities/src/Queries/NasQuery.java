/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Queries;

import java.util.ArrayList;
import java.util.List;
import luars.entity.Nas;
import luars.util.HibernateUtil;
import org.hibernate.Criteria;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.criterion.Order;
import org.hibernate.criterion.Restrictions;

/**
 *
 * @author dreed
 */
public class NasQuery {

    Session session;
    Criteria criteria;

    public NasQuery() {
        Session session = HibernateUtil.getSessionFactory().
                openSession();
        session.beginTransaction();

        criteria = session.createCriteria(Nas.class);
    }

    public void byPing(double pingID) {
        criteria.createAlias("pings", "p").add(Restrictions.eq("p.pingId", (int)pingID));
        System.out.println("Added Track Criteria (Name)");
    }   

    public List getNas() {

        List resultList = new ArrayList();
        try {
            resultList = criteria.addOrder(Order.asc("timestamp")).list();

            session.getTransaction().
                    commit();
        } catch (HibernateException he) {
            he.printStackTrace();
        } finally {

            return resultList;

        }
    }

}
