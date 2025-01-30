package com.nlb.aop;


import org.aspectj.lang.annotation.AfterThrowing;
import org.aspectj.lang.annotation.Aspect;
import org.springframework.stereotype.Component;
import org.springframework.transaction.interceptor.TransactionAspectSupport;

//@Aspect
//@Component
public class DistributedTransactionAspect {

//    @AfterThrowing(pointcut = "execution(public * com.nlb.service.*Impl.*(..))", throwing = "ex")
    public void handleMongoException(Exception ex) {
        TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
    }
}