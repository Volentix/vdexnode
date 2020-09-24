import enum

from sqlalchemy import Column, Integer, String, DECIMAL, Enum
from sqlalchemy.ext.declarative import declarative_base

Base = declarative_base()


class ObjectNotFound(Exception):
    pass


class DepositStatus(enum.Enum):
    pending = 'PENDING'
    problem = 'PROBLEM'
    wating_for_submit = 'WATING_FOR_SUBMIT'
    wating_for_submit_confirmation = 'WATING_FOR_SUBMIT_CONFIRMATION'
    confirmed = 'CONFIRMED'


class AccountDeposit(Base):
    __tablename__ = 'account_deposit'
    id = Column(Integer, primary_key=True)
    currency = Column(String)
    account = Column(String)
    amount = DECIMAL(precision=20, scale=8)
    hash = Column(String)
    submit_hash = Column(String, nullable=True)
    status = Column(Enum(DepositStatus))

    def __repr__(self):
        return "<AccountDeposit('%s','%s', '%s')>" % (self.id, self.currency, self.name)


class GatewayTable(Base):
    __tablename__ = 'gateway_table'
    id = Column(Integer, primary_key=True)
    name = Column(String)
    currency = Column(String)
    last_row_read = Column(Integer, nullable=False, default=-1)
