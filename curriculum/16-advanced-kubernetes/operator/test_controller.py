import importlib.util
import pathlib
import unittest

MODULE_PATH = pathlib.Path(__file__).with_name("controller.py")
SPEC = importlib.util.spec_from_file_location("controller", MODULE_PATH)
controller = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(controller)


class DesiredConfigMapTests(unittest.TestCase):
    def test_maps_spec_and_controller_owner(self):
        resource = {
            "apiVersion": "learning.cloudcart.io/v1alpha1",
            "kind": "CloudCartPolicy",
            "metadata": {"name": "sample", "namespace": "operator-lab", "uid": "test-uid"},
            "spec": {"message": "hello"},
        }
        result = controller.desired_configmap(resource)
        self.assertEqual(result["metadata"]["name"], "policy-sample")
        self.assertEqual(result["data"], {"message": "hello"})
        self.assertTrue(result["metadata"]["ownerReferences"][0]["controller"])


if __name__ == "__main__":
    unittest.main()
