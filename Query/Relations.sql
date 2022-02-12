ALTER TABLE MyTable NOCHECK CONSTRAINT ALL

-- Enable all table constraints

ALTER TABLE MyTable WITH CHECK CHECK CONSTRAINT ALL

-- Disable single constraint

ALTER TABLE MyTable NOCHECK CONSTRAINT MyConstraint

-- Enable single constraint

ALTER TABLE MyTable WITH CHECK CHECK CONSTRAINT MyConstraint