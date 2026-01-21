#!/usr/bin/env python3
"""
One-time migration: encrypt existing Tesla tokens in Firestore.

This script finds all Tesla token documents with unencrypted tokens
and re-encrypts them using KMS.

Run with: python -m scripts.migrate_tesla_tokens

Requirements:
- KMS key must be created and accessible
- Service account must have KMS encrypt/decrypt permissions
"""

import json
import logging
import sys

logging.basicConfig(level=logging.INFO, format="%(asctime)s - %(levelname)s - %(message)s")
logger = logging.getLogger(__name__)


def migrate_tesla_tokens(dry_run: bool = False):
    """
    Migrate unencrypted Tesla tokens to encrypted format.

    Args:
        dry_run: If True, only report what would be migrated without making changes
    """
    from google.cloud import firestore
    from utils.encryption import encrypt_dict, is_encrypted

    db = firestore.Client()
    cache_ref = db.collection("cache")

    # Find all Tesla token documents
    migrated = 0
    skipped = 0
    errors = 0

    # Query for documents that start with tesla_tokens_
    docs = list(cache_ref.stream())

    for doc in docs:
        if not doc.id.startswith("tesla_tokens_"):
            continue

        data = doc.to_dict()
        if not data:
            continue

        # Skip if already encrypted
        if "tokens_encrypted" in data:
            logger.info(f"Skipping {doc.id} - already encrypted")
            skipped += 1
            continue

        # Skip if no tokens field
        if "tokens" not in data:
            logger.info(f"Skipping {doc.id} - no tokens field")
            skipped += 1
            continue

        try:
            # Parse the unencrypted tokens
            tokens = json.loads(data["tokens"])

            if dry_run:
                logger.info(f"[DRY RUN] Would migrate {doc.id}")
                migrated += 1
                continue

            # Encrypt and update
            encrypted = encrypt_dict(tokens)

            doc.reference.update({
                "tokens_encrypted": encrypted,
                "encryption_version": "kms-v1",
                "tokens": firestore.DELETE_FIELD,  # Remove plaintext!
            })

            logger.info(f"Migrated {doc.id}")
            migrated += 1

        except json.JSONDecodeError as e:
            logger.error(f"Failed to parse tokens for {doc.id}: {e}")
            errors += 1
        except Exception as e:
            logger.error(f"Failed to migrate {doc.id}: {e}")
            errors += 1

    print(f"\n{'[DRY RUN] ' if dry_run else ''}Migration complete:")
    print(f"  Migrated: {migrated}")
    print(f"  Skipped:  {skipped}")
    print(f"  Errors:   {errors}")

    return migrated, skipped, errors


def main():
    """Run the migration."""
    import argparse

    parser = argparse.ArgumentParser(description="Migrate Tesla tokens to encrypted format")
    parser.add_argument(
        "--dry-run",
        action="store_true",
        help="Show what would be migrated without making changes",
    )
    parser.add_argument(
        "--force",
        action="store_true",
        help="Run without confirmation prompt",
    )
    args = parser.parse_args()

    if not args.dry_run and not args.force:
        confirm = input("This will encrypt all Tesla tokens in Firestore. Continue? [y/N] ")
        if confirm.lower() != "y":
            print("Aborted.")
            sys.exit(0)

    migrated, skipped, errors = migrate_tesla_tokens(dry_run=args.dry_run)

    if errors > 0:
        sys.exit(1)


if __name__ == "__main__":
    main()
