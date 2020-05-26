#!/usr/bin/python
import copy, datetime, json, os, sys
import locking

dbDir = 'db'
dbFile = 'course.json'
backupDir = 'backup'
header = 'Content-type: application/json\n\n'

for dirname in [dbDir, backupDir]:
  try:
    os.mkdir(dirname, 0o700)
  except Exception:
    pass

try:
  op = json.load(sys.stdin)
  readOnly = not op

  db = locking.open_or_create_and_lock(os.path.join(dbDir, dbFile), readOnly)
  raw = db.read()
  if not raw: # initially empty file
    raw = '{}'
  if not readOnly:
    data = json.loads(raw)
    orig = copy.deepcopy(data)
    for key in ['title']:
      if key in op:
        data[key] = op[key]
    if data != orig:
      raw = json.dumps(data)
      backup = open(os.path.join(backupDir, datetime.datetime.now().strftime('%Y-%m-%d_%H-%M-%S-%f.json')), 'w')
      backup.write(raw)
      db.seek(0)
      db.truncate(0)
      db.write(raw)

  locking.unlock(db)
  db.close()
except Exception:
  kind, value = sys.exc_info()[:2]
  raw = '%s: %s' % (kind.__name__, value)
  header = 'Content-type: text/plain\nStatus: 400 Bad Request\n\n'

sys.stdout.write(header + raw)
