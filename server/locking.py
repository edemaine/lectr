"""File locking via fcntl"""

import os, warnings
import fcntl

def open_and_lock(filename, mode):
  f = open(filename, mode)
  lock(f, readonly = ('r' in mode and '+' not in mode))
  return f

def open_existing_and_lock (filename, readonly):
  if readonly:
    mode = 'r'
  else:
    mode = 'r+'
  f = open(filename, mode)
  lock(f, readonly)
  return f

def create_and_lock(filename):
  f = open(filename, 'w+')
  lock(f, readonly = False)
  return f

def open_or_create_and_lock(filename, readonly, chmod = 0o600, binary = False):
  f = os.open(filename, os.O_CREAT | os.O_RDWR, chmod)
  #if readonly:
  #  mode = 'r'
  #else:
  mode = 'r+'
  if binary:
    mode += 'b'
  f = os.fdopen(f, mode)
  lock(f, readonly)
  return f

def lock(file, readonly):
  if readonly:
    lock_readonly(file)
  else:
    lock_readwrite(file)

## fcntl-specific code

def lock_readonly(file):
  fcntl.flock(file.fileno(), fcntl.LOCK_SH)
def lock_readwrite(file):
  fcntl.flock(file.fileno(), fcntl.LOCK_EX)
def unlock(file):
  fcntl.flock(file.fileno(), fcntl.LOCK_UN)
