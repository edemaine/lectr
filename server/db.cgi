#!/usr/bin/python
import copy, datetime, json, os, sys, time, uuid
import locking

'''
Lectr server-side CGI script: read and optionally modify the database

The body of a request should have one of the following forms:
  1. '{}' (null operation)
  2. JSON-encoded object describing operation to perform
  3. JSON-encoded object, followed by form-feed character, then a binary file

In all cases, the response is a JSON dump of the entire database.
'''

dbDir = 'db'
dbFile = 'course.json'
backupDir = 'backup'
filesDir = 'files'
header = 'Content-type: application/json\n\n'

os.chdir(os.path.dirname(__file__))
for dirname in [dbDir, backupDir, filesDir]:
  try:
    os.mkdir(dirname, 0o700)
  except Exception:
    pass

def now():
  return time.time() * 1000 # msec for JavaScript

try:
  fileData = None
  inputData = sys.stdin.read()
  if '\f' in inputData:
    jsonData, fileData = inputData.split('\f', 1)
  else:
    jsonData = inputData
  op = json.loads(jsonData)
  readOnly = not op

  db = locking.open_or_create_and_lock(os.path.join(dbDir, dbFile), readOnly)
  raw = db.read()
  if not raw: # initially empty file
    raw = '{}'
  if not readOnly:
    data = json.loads(raw)
    orig = copy.deepcopy(data)

    # Simple key/value storage
    for key in ['title']:
      if key in op:
        data[key] = op[key]

    # Document Types and Lectures
    for kind in ['docType', 'lecture']:
      plural = kind + 's'
      if plural not in data:
        data[plural] = []
      if kind in op:
        doc = op[kind]
        doc['updated'] = now()
        if '_id' not in doc: # new
          doc['_id'] = uuid.uuid4().hex
          doc['created'] = doc['updated']
          data[plural].append(doc)
        else:
          existing = [_ for _ in data[plural] if _['_id'] == doc['_id']][0]
          for key, value in doc.items():
            existing[key] = value
    data['lectures'].sort(key = lambda L: L.get('number'))

    # File upload
    if 'files' not in data:
      data['files'] = {}
    if 'file' in op:
      doc = op['file']
      doc['updated'] = now()
      if '_id' not in doc: # new
        doc['_id'] = uuid.uuid4().hex
        doc['created'] = doc['updated']
        data['files'][doc['_id']] = doc
      else:
        existing = data['files'][doc['_id']]
        if 'delete' in op:
          os.remove(os.path.join(filesDir, doc['_id']))
          del data['files'][doc['_id']]
          fileData = None
        else:
          for key, value in doc.items():
            existing[key] = value
      if fileData is not None:
        lockedFile = locking.open_or_create_and_lock(
          os.path.join(filesDir, doc['_id']), False, binary = True)
        lockedFile.seek(0)
        lockedFile.truncate(0)
        lockedFile.write(fileData)
        lockedFile.flush()
        locking.unlock(lockedFile)
        lockedFile.close()

    if data != orig:
      raw = json.dumps(data)
      backup = open(os.path.join(backupDir, datetime.datetime.now().strftime('%Y-%m-%d_%H-%M-%S-%f.json')), 'w')
      backup.write(raw)
      backup.close()
      db.seek(0)
      db.truncate(0)
      db.write(raw)
      db.flush()

  locking.unlock(db)
  db.close()
except Exception:
  kind, value = sys.exc_info()[:2]
  raw = '%s: %s' % (kind.__name__, value)
  header = 'Content-type: text/plain\nStatus: 400 Bad Request\n\n'

sys.stdout.write(header + raw)
