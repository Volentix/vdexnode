import enum
from sqlalchemy import Column, Integer, String, create_engine, DECIMAL, Enum
from sqlalchemy.ext.declarative import declarative_base

# engine = create_engine('sqlite:///:memory:', echo=True)

Base = declarative_base()


class DepositStatus(enum.Enum):
    pending = 'PENDING'
    wating_for_submit = 'WATING_FOR_SUBMIT'
    wating_for_submit_confirmation = 'WATING_FOR_SUBMIT_CONFIRMATION'
    confirmed = 'CONFIRMED'


class CRUD:
    def save(self):
        self.db_session.add(self)
        return self.db_session.commit()

    def delete(self):
        self.db_session.delete(self)
        return self.db_session.commit()

    def get(self, **kwargs):
        instance = self.db_session.query(self).filter_by(**kwargs).first()
        if instance:
            return instance
        else:
            raise ValueError('object not found')


class AccountDeposit(Base, CRUD):
    __tablename__ = 'account_deposit'
    id = Column(Integer, primary_key=True)
    currency = Column(String)
    name = Column(String)
    amount = DECIMAL(precision=20, scale=8)
    hash = Column(String)
    submit_hash = Column(String, nullable=True)
    status = Column(Enum(DepositStatus))

    db_session = None

    def __init__(self, id, currency, name, amount, hash):
        self.id = id
        self.currency = currency
        self.name = name
        self.amount = amount
        self.hash = hash
        self.status = DepositStatus.pending

    def __repr__(self):
        return "<AccountDeposit('%s','%s', '%s')>" % (self.id, self.currency, self.name)

    @staticmethod
    def set_db_session(db_session):
        if AccountDeposit.db_session is None:
            AccountDeposit.db_session = db_session


class GatewayTable(Base, CRUD):
    __tablename__ = 'gateway_table'
    id = Column(Integer, primary_key=True)
    name = Column(String)
    last_row_read = Column(Integer, nullable=False, default=-1)

    @staticmethod
    def set_db_session(db_session):
        if AccountDeposit.db_session is None:
            AccountDeposit.db_session = db_session
