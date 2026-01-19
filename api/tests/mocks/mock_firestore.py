"""Mock Firestore client for testing."""

from typing import Any
from datetime import datetime


class MockDocumentSnapshot:
    """Mock Firestore document snapshot."""

    def __init__(self, data: dict | None, doc_id: str = "trip_start"):
        self._data = data
        self.id = doc_id

    @property
    def exists(self) -> bool:
        return self._data is not None

    def to_dict(self) -> dict | None:
        return self._data


class MockDocumentReference:
    """Mock Firestore document reference."""

    def __init__(self, storage: dict, path: str):
        self._storage = storage
        self._path = path

    def get(self) -> MockDocumentSnapshot:
        data = self._storage.get(self._path)
        return MockDocumentSnapshot(data, self._path.split("/")[-1])

    def set(self, data: dict, merge: bool = False) -> None:
        if merge and self._path in self._storage:
            self._storage[self._path] = {**self._storage[self._path], **data}
        else:
            self._storage[self._path] = data

    def update(self, data: dict) -> None:
        if self._path in self._storage:
            self._storage[self._path].update(data)
        else:
            self._storage[self._path] = data

    def delete(self) -> None:
        if self._path in self._storage:
            del self._storage[self._path]


class MockCollectionReference:
    """Mock Firestore collection reference."""

    def __init__(self, storage: dict, path: str):
        self._storage = storage
        self._path = path

    def document(self, doc_id: str) -> MockDocumentReference:
        return MockDocumentReference(self._storage, f"{self._path}/{doc_id}")

    def add(self, data: dict) -> tuple[Any, MockDocumentReference]:
        doc_id = f"auto-{datetime.now().timestamp()}"
        doc_ref = self.document(doc_id)
        doc_ref.set(data)
        return None, doc_ref

    def stream(self):
        """Yield documents in this collection."""
        prefix = self._path + "/"
        for path, data in self._storage.items():
            if path.startswith(prefix) and path.count("/") == prefix.count("/"):
                doc_id = path.split("/")[-1]
                yield MockDocumentSnapshot(data, doc_id)


class MockFirestore:
    """Mock Firestore client for testing trip cache operations."""

    def __init__(self):
        self._storage: dict[str, dict] = {}

    def collection(self, name: str) -> MockCollectionReference:
        return MockCollectionReference(self._storage, name)

    # === Test Helper Methods ===

    def set_trip_cache(self, user_id: str, cache: dict) -> None:
        """Directly set trip cache for testing."""
        path = f"users/{user_id}/cache/trip_start"
        self._storage[path] = cache

    def get_trip_cache(self, user_id: str) -> dict | None:
        """Directly get trip cache for verification."""
        path = f"users/{user_id}/cache/trip_start"
        return self._storage.get(path)

    def clear_trip_cache(self, user_id: str) -> None:
        """Clear trip cache."""
        path = f"users/{user_id}/cache/trip_start"
        if path in self._storage:
            del self._storage[path]

    def set_car_credentials(self, user_id: str, car_id: str, credentials: dict) -> None:
        """Set car credentials for testing."""
        path = f"users/{user_id}/cars/{car_id}/credentials/api"
        self._storage[path] = credentials

    def reset(self) -> None:
        """Clear all stored data."""
        self._storage.clear()

    def dump(self) -> dict:
        """Return all stored data for debugging."""
        return dict(self._storage)
